import XCTest
@testable import SudokuAppCore

final class DifficultyClassificationTests: XCTestCase {
    func testHeuristicClassificationReturnsExpectedBucket() {
        let analyzer = DifficultyAnalysisService()
        let dense = Array(repeating: Array(repeating: Optional(1), count: 9), count: 9)

        XCTAssertEqual(analyzer.classify(board: dense), .easy)
    }
}
