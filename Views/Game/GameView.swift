#if canImport(SwiftUI)
import SwiftUI

struct GameView: View {
    @StateObject var viewModel: GameViewModel

    var body: some View {
        VStack(spacing: 12) {
            Text(viewModel.difficulty.displayName)
                .font(.headline)

            Text("Hints: \(viewModel.snapshot.remainingHints)")
            if viewModel.snapshot.remainingLives > 0 {
                Text("Lives: \(viewModel.snapshot.remainingLives)")
            }

            SudokuGridView(board: viewModel.board) { row, col in
                viewModel.selectCell(row: row, col: col)
            }

            NumberPadView { number in
                viewModel.placeNumber(number)
            }

            HStack {
                Button("Erase") { viewModel.eraseSelectedCell() }
                Button("Hint") { viewModel.useHint() }
                    .disabled(viewModel.snapshot.remainingHints == 0)
                Button("Undo") { viewModel.undoLastAction() }
                Button("Give Up", role: .destructive) { viewModel.giveUp() }
            }
            .buttonStyle(.bordered)
        }
        .padding()
    }
}
#endif
