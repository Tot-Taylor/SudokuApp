import Foundation

@MainActor
final class GameViewModel: ObservableObject {
    @Published private(set) var snapshot: SavedGameSnapshot

    var board: SudokuBoardState { snapshot.puzzleBoard }
    var difficulty: Difficulty { snapshot.difficulty }
    var isEnded: Bool { snapshot.isFinished }

    private let persistence: GamePersistenceServiceProtocol

    init(snapshot: SavedGameSnapshot, persistence: GamePersistenceServiceProtocol) {
        self.snapshot = snapshot
        self.persistence = persistence
    }

    func selectCell(row: Int, col: Int) {
        snapshot.selectedRow = row
        snapshot.selectedCol = col
        persist()
    }

    func placeNumber(_ value: Int) {
        guard let row = snapshot.selectedRow,
              let col = snapshot.selectedCol,
              !snapshot.isFinished
        else { return }

        var cell = snapshot.puzzleBoard.cell(row: row, col: col)
        guard cell.isEditable else { return }

        let previousValue = cell.currentValue
        let previousOrigin = cell.origin
        cell.currentValue = value
        cell.origin = .user

        snapshot.puzzleBoard.updateCell(row: row, col: col) { $0 = cell }
        snapshot.undoStack.append(
            UndoEntry(row: row, col: col, previousValue: previousValue, newValue: value, previousOrigin: previousOrigin, newOrigin: .user, actionType: .placement)
        )
        persist()
    }

    func eraseSelectedCell() {
        guard let row = snapshot.selectedRow,
              let col = snapshot.selectedCol,
              !snapshot.isFinished
        else { return }

        let cell = snapshot.puzzleBoard.cell(row: row, col: col)
        guard cell.isEditable else { return }

        snapshot.undoStack.append(
            UndoEntry(row: row, col: col, previousValue: cell.currentValue, newValue: nil, previousOrigin: cell.origin, newOrigin: nil, actionType: .erase)
        )

        snapshot.puzzleBoard.updateCell(row: row, col: col) {
            $0.currentValue = nil
            $0.origin = nil
        }
        persist()
    }

    func useHint() {
        guard snapshot.remainingHints > 0,
              let row = snapshot.selectedRow,
              let col = snapshot.selectedCol,
              !snapshot.isFinished
        else { return }

        let cell = snapshot.puzzleBoard.cell(row: row, col: col)
        guard cell.isEditable else { return }

        snapshot.remainingHints -= 1
        snapshot.undoStack.append(
            UndoEntry(row: row, col: col, previousValue: cell.currentValue, newValue: cell.solutionValue, previousOrigin: cell.origin, newOrigin: .hint, actionType: .hint)
        )
        snapshot.puzzleBoard.updateCell(row: row, col: col) {
            $0.currentValue = $0.solutionValue
            $0.origin = .hint
        }
        persist()
    }

    func undoLastAction() {
        guard !snapshot.isFinished,
              let undo = snapshot.undoStack.popLast()
        else { return }

        snapshot.puzzleBoard.updateCell(row: undo.row, col: undo.col) {
            $0.currentValue = undo.previousValue
            $0.origin = undo.previousOrigin
        }
        persist()
    }

    func giveUp() {
        guard !snapshot.isFinished else { return }
        revealSolution(endReason: .gaveUp)
    }

    func revealAsOutOfLives() {
        guard !snapshot.isFinished else { return }
        revealSolution(endReason: .outOfLives)
    }

    private func revealSolution(endReason: GameEndReason) {
        for row in 0..<9 {
            for col in 0..<9 {
                snapshot.puzzleBoard.updateCell(row: row, col: col) {
                    $0.currentValue = $0.solutionValue
                }
            }
        }
        snapshot.isFinished = true
        snapshot.endReason = endReason
        persist()
    }

    private func persist() {
        persistence.save(snapshot)
    }
}
