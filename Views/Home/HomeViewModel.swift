#if canImport(Combine)
import Foundation
import Combine

@MainActor
final class HomeViewModel: ObservableObject {
    @Published var totalPoints: Int = 0
    @Published var canContinue: Bool = false
    @Published var isGenerating = false
    @Published var isRegenerating = false

    private let container: AppContainer
    private var profile = PlayerProfile.default

    init(container: AppContainer) {
        self.container = container
        refresh()
    }

    func refresh() {
        canContinue = container.gamePersistenceService.load() != nil
        totalPoints = profile.totalPoints
    }

    func startNewGame(difficulty: Difficulty, seed: UInt64? = nil) async -> SavedGameSnapshot {
        isGenerating = true
        defer {
            isGenerating = false
            isRegenerating = false
        }

        let settings = container.settingsService.loadSettings()
        let initialSeed = seed ?? UInt64.random(in: UInt64.min...UInt64.max)
        var attemptSeed = initialSeed

        let puzzleAndSolution: ([[Int?]], [[Int]]) = {
            while true {
                do {
                    return try container.puzzleGenerator.generatePuzzle(for: difficulty, seed: attemptSeed, maxAttempts: 25)
                } catch {
                    isRegenerating = true
                    attemptSeed &+= 1
                }
            }
        }()

        let (puzzle, solution) = puzzleAndSolution

        let cells = (0..<81).map { idx -> CellState in
            let row = idx / 9
            let col = idx % 9
            let given = puzzle[row][col]
            return CellState(
                row: row,
                col: col,
                solutionValue: solution[row][col],
                givenValue: given,
                currentValue: given,
                origin: given == nil ? nil : .given
            )
        }

        let snapshot = SavedGameSnapshot(
            id: UUID(),
            difficulty: difficulty,
            puzzleBoard: SudokuBoardState(cells: cells),
            startedAt: Date(),
            elapsedSeconds: 0,
            remainingHints: settings.hintsPerGame,
            remainingLives: settings.livesPerGame,
            undoStack: [],
            selectedRow: nil,
            selectedCol: nil,
            isFinished: false,
            endReason: nil,
            pointsAwarded: false
        )

        container.gamePersistenceService.save(snapshot)
        canContinue = true
        return snapshot
    }
}
#endif
