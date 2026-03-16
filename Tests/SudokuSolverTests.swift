import XCTest
@testable import SudokuAppCore

final class SudokuSolverTests: XCTestCase {
    func testValidPlacementCheckRejectsRowDuplicate() {
        let service = SudokuSolverService()
        var board = Array(repeating: Array(repeating: Optional<Int>.none, count: 9), count: 9)
        board[0][0] = 5

        XCTAssertFalse(service.isValidPlacement(5, row: 0, col: 1, board: board))
    }
}
