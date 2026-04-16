#if canImport(Combine)
import Foundation
import Combine

@MainActor
final class GameViewModel: ObservableObject, Identifiable {
    let id: UUID
    @Published private(set) var snapshot: SavedGameSnapshot
    @Published var isShowingCompletionPopup = false

    var board: SudokuBoardState { snapshot.puzzleBoard }
    var difficulty: Difficulty { snapshot.difficulty }
    var isEnded: Bool { snapshot.isFinished }

    private let persistence: GamePersistenceServiceProtocol
    private var hasHandledExitCleanup = false

    init(snapshot: SavedGameSnapshot, persistence: GamePersistenceServiceProtocol) {
        self.id = snapshot.id
        self.snapshot = snapshot
        self.persistence = persistence
    }

    func selectCell(row: Int, col: Int) {
        let cell = snapshot.puzzleBoard.cell(row: row, col: col)
        guard cell.isEditable else { return }
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
        evaluateCompletionIfNeeded()
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
        guard let row = snapshot.selectedRow,
              let col = snapshot.selectedCol,
              !snapshot.isFinished
        else { return }

        let cell = snapshot.puzzleBoard.cell(row: row, col: col)
        guard cell.isEditable else { return }

        snapshot.remainingHints = max(0, snapshot.remainingHints - 1)
        snapshot.undoStack.append(
            UndoEntry(row: row, col: col, previousValue: cell.currentValue, newValue: cell.solutionValue, previousOrigin: cell.origin, newOrigin: .hint, actionType: .hint)
        )
        snapshot.puzzleBoard.updateCell(row: row, col: col) {
            $0.currentValue = $0.solutionValue
            $0.origin = .hint
        }
        evaluateCompletionIfNeeded()
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

    private func evaluateCompletionIfNeeded() {
        let cells = snapshot.puzzleBoard.cells
        let isFilled = cells.allSatisfy { $0.currentValue != nil }
        guard isFilled else { return }

        let isSolved = cells.allSatisfy { $0.currentValue == $0.solutionValue }
        guard isSolved else { return }

        snapshot.isFinished = true
        snapshot.endReason = .solved
        isShowingCompletionPopup = true
        persistence.clear()
    }

    private func persist() {
        persistence.save(snapshot)
    }

    func handleLeavingGame() {
        guard !hasHandledExitCleanup else { return }
        hasHandledExitCleanup = true
        if snapshot.isFinished && snapshot.endReason == .solved {
            persistence.clear()
            return
        }
        persist()
    }

    func handleAppMovingToBackground() {
        if snapshot.isFinished && snapshot.endReason == .solved {
            persistence.clear()
            return
        }
        persist()
    }
}
#endif
