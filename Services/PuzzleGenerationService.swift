import Foundation

protocol PuzzleGenerationServiceProtocol {
    func generatePuzzle(for difficulty: Difficulty, seed: UInt64?, maxAttempts: Int) throws -> ([[Int?]], [[Int]])
}

enum PuzzleGenerationError: Error {
    case maxAttemptsReached
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

    func generatePuzzle(for difficulty: Difficulty, seed: UInt64? = nil, maxAttempts: Int = 40) throws -> ([[Int?]], [[Int]]) {
        let targetClueRange = clueRange(for: difficulty)
        let baseSeed = seed ?? UInt64.random(in: UInt64.min...UInt64.max)
        let difficultySalt = UInt64(abs(difficulty.rawValue.hashValue))

        for attempt in 0..<maxAttempts {
            var rng = SeededRandomNumberGenerator(seed: baseSeed ^ difficultySalt ^ UInt64(attempt))
            let solved = generateSolvedGrid(using: &rng)
            var puzzle = solved.map { $0.map(Optional.some) }
            let indices = (0..<81).shuffled(using: &rng)

            for index in indices {
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
            guard solver.solve(puzzle) != nil else { continue }
            let metrics = analyzer.metrics(for: puzzle)
            if targetClueRange.contains(clueCount), matchesExpectedComplexity(metrics, difficulty: difficulty) {
                return (puzzle, solved)
            }
        }

        throw PuzzleGenerationError.maxAttemptsReached
    }

    private func clueRange(for difficulty: Difficulty) -> ClosedRange<Int> {
        switch difficulty {
        case .easy: return 40...81
        case .medium: return 33...39
        case .hard: return 28...32
        case .expert: return 22...27
        }
    }

    private func matchesExpectedComplexity(_ metrics: DifficultyMetrics, difficulty: Difficulty) -> Bool {
        switch difficulty {
        case .easy:
            return metrics.solvedBySinglesOnly
        case .medium:
            return metrics.solvedBySinglesOnly
        case .hard:
            return metrics.requiresAdvancedSearch
        case .expert:
            return metrics.requiresAdvancedSearch
        }
    }

    private func generateSolvedGrid(using rng: inout SeededRandomNumberGenerator) -> [[Int]] {
        var board = Array(repeating: Array(repeating: Optional<Int>.none, count: 9), count: 9)
        _ = fillSolvedBoard(&board, using: &rng)
        return board.map { $0.map { $0 ?? 0 } }
    }

    private func fillSolvedBoard(_ board: inout [[Int?]], using rng: inout SeededRandomNumberGenerator) -> Bool {
        guard let (row, col) = nextEmpty(in: board) else { return true }

        for value in Array(1...9).shuffled(using: &rng) where solver.isValidPlacement(value, row: row, col: col, board: board) {
            board[row][col] = value
            if fillSolvedBoard(&board, using: &rng) {
                return true
            }
            board[row][col] = nil
        }

        return false
    }

    private func nextEmpty(in board: [[Int?]]) -> (Int, Int)? {
        for row in 0..<9 {
            for col in 0..<9 where board[row][col] == nil {
                return (row, col)
            }
        }
        return nil
    }
}

struct SeededRandomNumberGenerator: RandomNumberGenerator {
    private var state: UInt64

    init(seed: UInt64) {
        self.state = seed == 0 ? 0x9E3779B97F4A7C15 : seed
    }

    mutating func next() -> UInt64 {
        state = state &* 6364136223846793005 &+ 1442695040888963407
        return state
    }
}
