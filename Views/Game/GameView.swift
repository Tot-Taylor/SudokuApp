#if canImport(SwiftUI)
import SwiftUI

struct GameView: View {
    @StateObject var viewModel: GameViewModel
    @Environment(\.dismiss) private var dismiss
    @Environment(\.scenePhase) private var scenePhase

    var body: some View {
        VStack(spacing: 16) {
            SudokuGridView(
                board: viewModel.board,
                selectedRow: viewModel.snapshot.selectedRow,
                selectedCol: viewModel.snapshot.selectedCol,
                isInteractionEnabled: !viewModel.isEnded
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
            .disabled(viewModel.isEnded)
        }
        .padding()
        .overlay {
            if viewModel.isShowingCompletionPopup {
                completionPopup
            }
        }
        .navigationBarBackButtonHidden(true)
        .toolbar {
            ToolbarItem(placement: .topBarLeading) {
                Button {
                    viewModel.handleLeavingGame()
                    dismiss()
                } label: {
                    Label("Back", systemImage: "chevron.left")
                }
            }
        }
        .onChange(of: scenePhase) { _, newPhase in
            if newPhase == .background || newPhase == .inactive {
                viewModel.handleAppMovingToBackground()
            }
        }
        .onDisappear {
            viewModel.handleLeavingGame()
        }
    }

    private var completionPopup: some View {
        ZStack {
            Color.black.opacity(0.35)
                .ignoresSafeArea()

            VStack(spacing: 16) {
                Text("Congratulations!")
                    .font(.title2.bold())
                Text("You successfully completed the puzzle.")
                    .font(.body)
                    .multilineTextAlignment(.center)

                HStack(spacing: 12) {
                    Button("Back to Home") {
                        viewModel.isShowingCompletionPopup = false
                        viewModel.handleLeavingGame()
                        dismiss()
                    }
                    .buttonStyle(.borderedProminent)

                    Button("View Puzzle") {
                        viewModel.isShowingCompletionPopup = false
                    }
                    .buttonStyle(.bordered)
                }
            }
            .padding(24)
            .background(
                RoundedRectangle(cornerRadius: 16, style: .continuous)
                    .fill(Color(.systemBackground))
            )
            .padding(.horizontal, 24)
        }
    }
}
#endif
