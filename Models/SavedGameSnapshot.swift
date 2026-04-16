import Foundation

struct SavedGameSnapshot: Codable {
    let id: UUID
    let difficulty: Difficulty
    var puzzleBoard: SudokuBoardState
    let startedAt: Date
    var elapsedSeconds: Int
    var remainingHints: Int
    var remainingLives: Int
    var undoStack: [UndoEntry]
    var selectedRow: Int?
    var selectedCol: Int?
    var isFinished: Bool
    var endReason: GameEndReason?
    var pointsAwarded: Bool
}
