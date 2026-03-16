import Foundation

protocol SudokuSolverServiceProtocol {
    func solve(_ board: [[Int?]]) -> [[Int]]?
    func solutionCount(for board: [[Int?]], limit: Int) -> Int
    func isValidPlacement(_ value: Int, row: Int, col: Int, board: [[Int?]]) -> Bool
}

struct SudokuSolverService: SudokuSolverServiceProtocol {
    func solve(_ board: [[Int?]]) -> [[Int]]? {
        var mutable = board
        guard backtrackSolve(&mutable) else { return nil }
        return mutable.map { $0.map { $0 ?? 0 } }
    }

    func solutionCount(for board: [[Int?]], limit: Int = 2) -> Int {
        var mutable = board
        return countSolutions(&mutable, limit: limit)
    }

    func isValidPlacement(_ value: Int, row: Int, col: Int, board: [[Int?]]) -> Bool {
        for i in 0..<9 {
            if i != col, board[row][i] == value { return false }
            if i != row, board[i][col] == value { return false }
        }

        let boxRow = (row / 3) * 3
        let boxCol = (col / 3) * 3
        for r in boxRow..<(boxRow + 3) {
            for c in boxCol..<(boxCol + 3) {
                if (r != row || c != col), board[r][c] == value {
                    return false
                }
            }
        }

        return true
    }

    private func backtrackSolve(_ board: inout [[Int?]]) -> Bool {
        guard let (row, col) = nextEmpty(in: board) else { return true }

        let candidates = Array(1...9).shuffled()
        for value in candidates where isValidPlacement(value, row: row, col: col, board: board) {
            board[row][col] = value
            if backtrackSolve(&board) { return true }
            board[row][col] = nil
        }

        return false
    }

    private func countSolutions(_ board: inout [[Int?]], limit: Int, running: Int = 0) -> Int {
        var running = running
        guard let (row, col) = nextEmpty(in: board) else {
            return running + 1
        }

        for value in 1...9 where isValidPlacement(value, row: row, col: col, board: board) {
            board[row][col] = value
            running = countSolutions(&board, limit: limit, running: running)
            board[row][col] = nil
            if running >= limit { return running }
        }

        return running
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
