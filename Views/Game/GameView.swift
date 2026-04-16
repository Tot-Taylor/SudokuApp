#if canImport(SwiftUI)
import SwiftUI

struct GameView: View {
    @StateObject var viewModel: GameViewModel

    var body: some View {
        VStack(spacing: 16) {
            SudokuGridView(
                board: viewModel.board,
                selectedRow: viewModel.snapshot.selectedRow,
                selectedCol: viewModel.snapshot.selectedCol
            ) { row, col in
                viewModel.selectCell(row: row, col: col)
            }
            NumberPadView { value in
                viewModel.placeNumber(value)
            }
        }
        .padding()
    }
}
#endif
