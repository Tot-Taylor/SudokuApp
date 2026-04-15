#if canImport(SwiftUI)
import SwiftUI

struct GameView: View {
    @StateObject var viewModel: GameViewModel

    var body: some View {
        VStack {
            SudokuGridView(board: viewModel.board) { row, col in
                viewModel.selectCell(row: row, col: col)
            }
        }
        .padding()
    }
}
#endif
