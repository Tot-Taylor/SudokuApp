import Foundation

protocol PuzzleGenerationServiceProtocol {
    func generatePuzzle(for difficulty: Difficulty, seed: Int64?) -> ([[Int?]], [[Int]])?
    func generatePuzzle(for difficulty: Difficulty) -> ([[Int?]], [[Int]])
}

struct PuzzleGenerationService: PuzzleGenerationServiceProtocol {
    private let solver: SudokuSolverServiceProtocol
    private let analyzer: DifficultyAnalysisServiceProtocol
    private let maxAttemptsPerBatch: Int

    init(
        solver: SudokuSolverServiceProtocol = SudokuSolverService(),
        analyzer: DifficultyAnalysisServiceProtocol = DifficultyAnalysisService(),
        maxAttemptsPerBatch: Int = 60
    ) {
        self.solver = solver
        self.analyzer = analyzer
        self.maxAttemptsPerBatch = maxAttemptsPerBatch
    }

    func generatePuzzle(for difficulty: Difficulty) -> ([[Int?]], [[Int]]) {
        while true {
            let seed = Int64.random(in: Int64.min...Int64.max)
            if let generated = generatePuzzle(for: difficulty, seed: seed) {
                return generated
            }
        }
    }

    func generatePuzzle(for difficulty: Difficulty, seed: Int64?) -> ([[Int?]], [[Int]])? {
        var rng = SeededRandomNumberGenerator(seed: seed ?? Int64.random(in: Int64.min...Int64.max))
        let targetClueRange = clueRange(for: difficulty)

        for _ in 0..<maxAttemptsPerBatch {
            let solved = generateSolvedGrid(using: &rng)
            var puzzle = solved.map { row in row.map { Optional($0) } }

            for index in Array(0..<81).shuffled(using: &rng) {
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
            guard targetClueRange.contains(clueCount) else { continue }
            guard analyzer.classify(board: puzzle) == difficulty else { continue }
            guard solver.solutionCount(for: puzzle, limit: 2) == 1 else { continue }
            return (puzzle, solved)
        }

        return nil
    }

    private func clueRange(for difficulty: Difficulty) -> ClosedRange<Int> {
        switch difficulty {
        case .easy: return 40...81
        case .medium: return 33...39
        case .hard: return 28...32
        case .expert: return 22...27
        }
    }

    private func generateSolvedGrid<R: RandomNumberGenerator>(using rng: inout R) -> [[Int]] {
        let base = (0..<9).map { row in
            (0..<9).map { col in ((row * 3 + row / 3 + col) % 9) + 1 }
        }

        let digits = Array(1...9).shuffled(using: &rng)
        let rowOrder = permutedLineOrder(using: &rng)
        let colOrder = permutedLineOrder(using: &rng)

        return rowOrder.map { row in
            colOrder.map { col in
                let value = base[row][col]
                return digits[value - 1]
            }
        }
    }

    private func permutedLineOrder<R: RandomNumberGenerator>(using rng: inout R) -> [Int] {
        let bandOrder = [0, 1, 2].shuffled(using: &rng)
        var lines: [Int] = []

        for band in bandOrder {
            let local = [0, 1, 2].shuffled(using: &rng)
            lines.append(contentsOf: local.map { band * 3 + $0 })
        }

        return lines
    }
}
