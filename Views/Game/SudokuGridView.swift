#if canImport(SwiftUI)
import SwiftUI

struct SudokuGridView: View {
    let board: SudokuBoardState
    let selectedRow: Int?
    let selectedCol: Int?
    let isInteractionEnabled: Bool
    let onTap: (Int, Int) -> Void

    var body: some View {
        VStack(spacing: 0) {
            ForEach(0..<9, id: \.self) { row in
                HStack(spacing: 0) {
                    ForEach(0..<9, id: \.self) { col in
                        SudokuCellView(
                            cell: board.cell(row: row, col: col),
                            isSelected: selectedRow == row && selectedCol == col,
                            isInSelectedBand: selectedRow == row || selectedCol == col,
                            isInteractionEnabled: isInteractionEnabled
                        ) {
                            onTap(row, col)
                        }
                    }
                }
            }
        }
    }
}
#endif
