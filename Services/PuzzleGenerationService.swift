import Foundation

protocol PuzzleGenerationServiceProtocol {
    func generatePuzzle(for difficulty: Difficulty) -> ([[Int?]], [[Int]])
}

struct PuzzleGenerationService: PuzzleGenerationServiceProtocol {
    private let solver: SudokuSolverServiceProtocol
    private let analyzer: DifficultyAnalysisServiceProtocol

    init(
        solver: SudokuSolverServiceProtocol = SudokuSolverService(),
        analyzer: DifficultyAnalysisServiceProtocol = DifficultyAnalysisService()
    ) {
        self.solver = solver
        self.analyzer = analyzer
    }

    func generatePuzzle(for difficulty: Difficulty) -> ([[Int?]], [[Int]]) {
        let targetClueRange = clueRange(for: difficulty)

        while true {
            let solved = generateSolvedGrid()
            var puzzle = solved.map { $0.map(Optional.some) }

            for index in Array(0..<81).shuffled() {
                let row = index / 9
                let col = index % 9
                let removed = puzzle[row][col]
                puzzle[row][col] = nil

                if solver.solutionCount(for: puzzle, limit: 2) != 1 {
                    puzzle[row][col] = removed
                    continue
                }

                let clueCount = puzzle.flatMap { $0 }.compactMap { $0 }.count
                if clueCount <= targetClueRange.lowerBound {
                    break
                }
            }

            let clueCount = puzzle.flatMap { $0 }.compactMap { $0 }.count
            if targetClueRange.contains(clueCount) || analyzer.classify(board: puzzle) == difficulty {
                return (puzzle, solved)
            }
        }
    }

    private func clueRange(for difficulty: Difficulty) -> ClosedRange<Int> {
        switch difficulty {
        case .easy: return 40...81
        case .medium: return 33...39
        case .hard: return 28...32
        case .expert: return 22...27
        }
    }

    private func generateSolvedGrid() -> [[Int]] {
        let empty = Array(repeating: Array(repeating: Optional<Int>.none, count: 9), count: 9)
        return solver.solve(empty) ?? Array(repeating: Array(repeating: 0, count: 9), count: 9)
    }
}
