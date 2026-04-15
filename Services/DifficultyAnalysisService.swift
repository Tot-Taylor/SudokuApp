import Foundation

protocol DifficultyAnalysisServiceProtocol {
    func classify(board: [[Int?]]) -> Difficulty
}

struct DifficultyAnalysisService: DifficultyAnalysisServiceProtocol {
    func classify(board: [[Int?]]) -> Difficulty {
        let clueCount = board.flatMap { $0 }.compactMap { $0 }.count
        let metrics = evaluate(board: board)

        if metrics.unsolvedCells == 0 {
            if clueCount >= 40 && metrics.guessCount == 0 && metrics.maxGuessDepth == 0 {
                return .easy
            }
            return .medium
        }

        if metrics.guessCount <= 2 && metrics.maxGuessDepth <= 1 {
            return .hard
        }
        return .expert
    }

    private func evaluate(board: [[Int?]]) -> SolverMetrics {
        var working = board
        var metrics = SolverMetrics()

        while true {
            var changed = false

            for row in 0..<9 {
                for col in 0..<9 where working[row][col] == nil {
                    let candidates = candidatesForCell(row: row, col: col, board: working)
                    if candidates.count == 1, let value = candidates.first {
                        working[row][col] = value
                        metrics.nakedSinglesUsed += 1
                        changed = true
                    }
                }
            }

            for unit in units() {
                for value in 1...9 {
                    let openCells = unit.filter { working[$0.0][$0.1] == nil }
                    let possible = openCells.filter { candidatesForCell(row: $0.0, col: $0.1, board: working).contains(value) }
                    if possible.count == 1 {
                        let (row, col) = possible[0]
                        working[row][col] = value
                        metrics.hiddenSinglesUsed += 1
                        changed = true
                    }
                }
            }

            if !changed { break }
        }

        metrics.unsolvedCells = working.flatMap { $0 }.filter { $0 == nil }.count

        if metrics.unsolvedCells > 0 {
            let guessMetrics = guessComplexity(board: working)
            metrics.guessCount = guessMetrics.guessCount
            metrics.maxGuessDepth = guessMetrics.maxGuessDepth
        }

        return metrics
    }

    private func guessComplexity(board: [[Int?]]) -> (guessCount: Int, maxGuessDepth: Int) {
        var mutable = board
        var guessCount = 0
        var maxDepth = 0
        _ = solveWithGuesses(&mutable, depth: 0, guessCount: &guessCount, maxDepth: &maxDepth)
        return (guessCount, maxDepth)
    }

    private func solveWithGuesses(_ board: inout [[Int?]], depth: Int, guessCount: inout Int, maxDepth: inout Int) -> Bool {
        guard let (row, col) = nextUnsolvedWithFewestCandidates(board: board) else { return true }
        let candidates = candidatesForCell(row: row, col: col, board: board)
        if candidates.isEmpty { return false }

        if candidates.count > 1 {
            guessCount += 1
            maxDepth = max(maxDepth, depth + 1)
        }

        for value in candidates {
            board[row][col] = value
            if solveWithGuesses(&board, depth: depth + 1, guessCount: &guessCount, maxDepth: &maxDepth) {
                return true
            }
            board[row][col] = nil
        }

        return false
    }

    private func nextUnsolvedWithFewestCandidates(board: [[Int?]]) -> (Int, Int)? {
        var best: (Int, Int)?
        var bestCount = Int.max

        for row in 0..<9 {
            for col in 0..<9 where board[row][col] == nil {
                let count = candidatesForCell(row: row, col: col, board: board).count
                if count < bestCount {
                    bestCount = count
                    best = (row, col)
                }
            }
        }

        return best
    }

    private func candidatesForCell(row: Int, col: Int, board: [[Int?]]) -> [Int] {
        guard board[row][col] == nil else { return [] }
        return (1...9).filter { value in
            !board[row].contains(value)
            && !board.map({ $0[col] }).contains(value)
            && !boxValues(row: row, col: col, board: board).contains(value)
        }
    }

    private func boxValues(row: Int, col: Int, board: [[Int?]]) -> [Int?] {
        let boxRow = (row / 3) * 3
        let boxCol = (col / 3) * 3
        return (boxRow..<(boxRow + 3)).flatMap { r in
            (boxCol..<(boxCol + 3)).map { c in board[r][c] }
        }
    }

    private func units() -> [[(Int, Int)]] {
        var allUnits: [[(Int, Int)]] = []

        for row in 0..<9 {
            allUnits.append((0..<9).map { (row, $0) })
        }

        for col in 0..<9 {
            allUnits.append((0..<9).map { ($0, col) })
        }

        for boxRow in stride(from: 0, to: 9, by: 3) {
            for boxCol in stride(from: 0, to: 9, by: 3) {
                var box: [(Int, Int)] = []
                for r in boxRow..<(boxRow + 3) {
                    for c in boxCol..<(boxCol + 3) {
                        box.append((r, c))
                    }
                }
                allUnits.append(box)
            }
        }

        return allUnits
    }
}

private struct SolverMetrics {
    var nakedSinglesUsed = 0
    var hiddenSinglesUsed = 0
    var unsolvedCells = 0
    var guessCount = 0
    var maxGuessDepth = 0
}
