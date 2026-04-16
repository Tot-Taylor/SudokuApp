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
            NumberPadView(
                onNumberTap: { value in
                    viewModel.placeNumber(value)
                },
                onHintTap: {
                    viewModel.useHint()
                },
                onEraseTap: {
                    viewModel.eraseSelectedCell()
                }
            )
        }
        .padding()
    }
}
#endif
