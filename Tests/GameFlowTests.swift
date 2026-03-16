import XCTest
@testable import SudokuApp

final class GameFlowTests: XCTestCase {
    func testDifficultyRewardValues() {
        XCTAssertEqual(DifficultyReward.points(for: .easy), 1)
        XCTAssertEqual(DifficultyReward.points(for: .medium), 5)
        XCTAssertEqual(DifficultyReward.points(for: .hard), 10)
        XCTAssertEqual(DifficultyReward.points(for: .expert), 25)
    }
}
