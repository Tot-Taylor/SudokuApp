#if canImport(Combine)
import Foundation
import Combine

@MainActor
final class HomeViewModel: ObservableObject {
    @Published var totalPoints: Int = 0
    @Published var canContinue: Bool = false
    @Published var isGeneratingPuzzle: Bool = false
    @Published var isRegeneratingPuzzle: Bool = false

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

    func startNewGame(difficulty: Difficulty, seed: Int64? = nil) async -> SavedGameSnapshot {
        isGeneratingPuzzle = true
        isRegeneratingPuzzle = false

        defer {
            isGeneratingPuzzle = false
            isRegeneratingPuzzle = false
        }

        let settings = container.settingsService.loadSettings()
        let puzzleGenerator = self.container.puzzleGenerator
        var attemptOffset: Int64 = 0
        var generated: ([[Int?]], [[Int]])?

        while generated == nil {
            let effectiveSeed = seed.map { $0 &+ attemptOffset }
            generated = await Task.detached(priority: .userInitiated) { [puzzleGenerator, difficulty, effectiveSeed] in
                puzzleGenerator.generatePuzzle(for: difficulty, seed: effectiveSeed)
            }.value

            if generated == nil {
                isRegeneratingPuzzle = true
                attemptOffset += 1
            }
        }

        let (puzzle, solution) = generated ?? puzzleGenerator.generatePuzzle(for: difficulty)

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
