import XCTest
@testable import SudokuApp

final class PuzzleUniquenessTests: XCTestCase {
    func testGeneratedPuzzleHasUniqueSolution() throws {
        let generator = PuzzleGenerationService()
        let (puzzle, _) = try generator.generatePuzzle(for: .easy)
        let solver = SudokuSolverService()

        XCTAssertEqual(solver.solutionCount(for: puzzle, limit: 2), 1)
    }

    func testGenerationIsDeterministicForSameSeed() throws {
        let generator = PuzzleGenerationService()
        let first = try generator.generatePuzzle(for: .medium, seed: 42, maxAttempts: 30).0
        let second = try generator.generatePuzzle(for: .medium, seed: 42, maxAttempts: 30).0

        XCTAssertEqual(first, second)
    }
}
