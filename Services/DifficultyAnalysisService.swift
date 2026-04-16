import Foundation

protocol DifficultyAnalysisServiceProtocol {
    func classify(board: [[Int?]]) -> Difficulty
    func metrics(for board: [[Int?]]) -> DifficultyMetrics
}

struct DifficultyMetrics {
    let clueCount: Int
    let solvedBySinglesOnly: Bool
    let requiresAdvancedSearch: Bool
}

struct DifficultyAnalysisService: DifficultyAnalysisServiceProtocol {
    func classify(board: [[Int?]]) -> Difficulty {
        let result = metrics(for: board)

        if result.solvedBySinglesOnly {
            return result.clueCount >= 40 ? .easy : .medium
        }

        if result.requiresAdvancedSearch {
            return result.clueCount <= 27 ? .expert : .hard
        }

        return .hard
    }

    func metrics(for board: [[Int?]]) -> DifficultyMetrics {
        let clues = board.flatMap { $0 }.compactMap { $0 }.count
        var working = board
        applySinglesStrategies(to: &working)

        let solvedBySinglesOnly = isSolved(working)
        let requiresAdvancedSearch = !solvedBySinglesOnly && requiresGuessing(working)

        return DifficultyMetrics(
            clueCount: clues,
            solvedBySinglesOnly: solvedBySinglesOnly,
            requiresAdvancedSearch: requiresAdvancedSearch
        )
    }

    private func applySinglesStrategies(to board: inout [[Int?]]) {
        var didChange = true
        while didChange {
            didChange = false
            didChange = fillNakedSingles(on: &board) || didChange
            didChange = fillHiddenSingles(on: &board) || didChange
        }
    }

    private func fillNakedSingles(on board: inout [[Int?]]) -> Bool {
        var changed = false
        for row in 0..<9 {
            for col in 0..<9 where board[row][col] == nil {
                let candidates = candidatesForCell(row: row, col: col, board: board)
                if candidates.count == 1 {
                    board[row][col] = candidates[0]
                    changed = true
                }
            }
        }
        return changed
    }

    private func fillHiddenSingles(on board: inout [[Int?]]) -> Bool {
        var changed = false

        for row in 0..<9 {
            changed = placeHiddenSingles(in: positionsForRow(row), board: &board) || changed
        }
        for col in 0..<9 {
            changed = placeHiddenSingles(in: positionsForCol(col), board: &board) || changed
        }

        for boxRow in stride(from: 0, to: 9, by: 3) {
            for boxCol in stride(from: 0, to: 9, by: 3) {
                changed = placeHiddenSingles(in: positionsForBox(boxRow: boxRow, boxCol: boxCol), board: &board) || changed
            }
        }

        return changed
    }

    private func placeHiddenSingles(in positions: [(Int, Int)], board: inout [[Int?]]) -> Bool {
        var changed = false
        var locationsByCandidate: [Int: [(Int, Int)]] = [:]

        for (row, col) in positions where board[row][col] == nil {
            for candidate in candidatesForCell(row: row, col: col, board: board) {
                locationsByCandidate[candidate, default: []].append((row, col))
            }
        }

        for (candidate, candidatePositions) in locationsByCandidate where candidatePositions.count == 1 {
            let (row, col) = candidatePositions[0]
            board[row][col] = candidate
            changed = true
        }

        return changed
    }

    private func requiresGuessing(_ board: [[Int?]]) -> Bool {
        var mutable = board
        return backtrackRequiresGuessing(&mutable)
    }

    private func backtrackRequiresGuessing(_ board: inout [[Int?]]) -> Bool {
        guard let (row, col) = nextEmpty(board) else { return false }

        let candidates = candidatesForCell(row: row, col: col, board: board)
        if candidates.isEmpty { return false }
        if candidates.count > 1 { return true }

        board[row][col] = candidates[0]
        return backtrackRequiresGuessing(&board)
    }

    private func candidatesForCell(row: Int, col: Int, board: [[Int?]]) -> [Int] {
        guard board[row][col] == nil else { return [] }
        return (1...9).filter { value in
            for i in 0..<9 {
                if board[row][i] == value || board[i][col] == value {
                    return false
                }
            }

            let boxRow = (row / 3) * 3
            let boxCol = (col / 3) * 3
            for r in boxRow..<(boxRow + 3) {
                for c in boxCol..<(boxCol + 3) where board[r][c] == value {
                    return false
                }
            }

            return true
        }
    }

    private func positionsForRow(_ row: Int) -> [(Int, Int)] {
        (0..<9).map { (row, $0) }
    }

    private func positionsForCol(_ col: Int) -> [(Int, Int)] {
        (0..<9).map { ($0, col) }
    }

    private func positionsForBox(boxRow: Int, boxCol: Int) -> [(Int, Int)] {
        var positions: [(Int, Int)] = []
        for row in boxRow..<(boxRow + 3) {
            for col in boxCol..<(boxCol + 3) {
                positions.append((row, col))
            }
        }
        return positions
    }

    private func nextEmpty(_ board: [[Int?]]) -> (Int, Int)? {
        for row in 0..<9 {
            for col in 0..<9 where board[row][col] == nil {
                return (row, col)
            }
        }
        return nil
    }

    private func isSolved(_ board: [[Int?]]) -> Bool {
        board.allSatisfy { row in row.allSatisfy { $0 != nil } }
    }
}
