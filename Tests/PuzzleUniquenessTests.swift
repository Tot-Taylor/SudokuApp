import XCTest
@testable import SudokuApp

final class PuzzleUniquenessTests: XCTestCase {
    func testGeneratedPuzzleHasUniqueSolution() {
        let generator = PuzzleGenerationService()
        let (puzzle, _) = generator.generatePuzzle(for: .easy)
        let solver = SudokuSolverService()

        XCTAssertEqual(solver.solutionCount(for: puzzle, limit: 2), 1)
    }

    func testGenerationIsDeterministicForSameSeed() {
        let generator = PuzzleGenerationService()

        let first = generator.generatePuzzle(for: .medium, seed: 4242)
        let second = generator.generatePuzzle(for: .medium, seed: 4242)

        XCTAssertEqual(first?.0, second?.0)
    }
}
