import Foundation

enum SudokuMath {
    static func boxIndex(row: Int, col: Int) -> Int {
        (row / 3) * 3 + (col / 3)
    }
}
