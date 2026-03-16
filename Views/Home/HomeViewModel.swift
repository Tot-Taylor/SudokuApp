import Foundation

@MainActor
final class HomeViewModel: ObservableObject {
    @Published var totalPoints: Int = 0
    @Published var canContinue: Bool = false

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

    func startNewGame(difficulty: Difficulty) -> SavedGameSnapshot {
        let settings = container.settingsService.loadSettings()
        let (puzzle, solution) = container.puzzleGenerator.generatePuzzle(for: difficulty)

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
