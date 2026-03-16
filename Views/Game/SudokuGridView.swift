#if canImport(SwiftUI)
import SwiftUI

struct SudokuGridView: View {
    let board: SudokuBoardState
    let onTap: (Int, Int) -> Void

    var body: some View {
        VStack(spacing: 2) {
            ForEach(0..<9, id: \.self) { row in
                HStack(spacing: 2) {
                    ForEach(0..<9, id: \.self) { col in
                        SudokuCellView(cell: board.cell(row: row, col: col)) {
                            onTap(row, col)
                        }
                    }
                }
            }
        }
    }
}
#endif
