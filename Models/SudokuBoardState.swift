import Foundation

struct SudokuBoardState: Codable, Hashable {
    var cells: [CellState]

    init(cells: [CellState]) {
        precondition(cells.count == 81, "Sudoku board must always contain 81 cells")
        self.cells = cells
    }

    func index(row: Int, col: Int) -> Int {
        row * 9 + col
    }

    func cell(row: Int, col: Int) -> CellState {
        cells[index(row: row, col: col)]
    }

    mutating func updateCell(row: Int, col: Int, _ mutate: (inout CellState) -> Void) {
        let idx = index(row: row, col: col)
        mutate(&cells[idx])
    }

    var isCompletelyFilled: Bool {
        cells.allSatisfy { $0.currentValue != nil }
    }
}
