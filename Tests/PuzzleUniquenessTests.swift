import XCTest
@testable import SudokuAppCore

final class PuzzleUniquenessTests: XCTestCase {
    func testGeneratedPuzzleHasUniqueSolution() {
        let generator = PuzzleGenerationService()
        let (puzzle, _) = generator.generatePuzzle(for: .easy)
        let solver = SudokuSolverService()

        XCTAssertEqual(solver.solutionCount(for: puzzle, limit: 2), 1)
    }
}
