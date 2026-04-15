#if canImport(SwiftUI)
import SwiftUI

struct HomeView: View {
    @StateObject var viewModel: HomeViewModel
    @State private var showDifficultyDialog = false
    @State private var activeSnapshot: SavedGameSnapshot?

    var body: some View {
        NavigationStack {
            VStack(spacing: 16) {
                Text("Sudoku")
                    .font(.largeTitle.bold())

                Text("Points: \(viewModel.totalPoints)")
                    .font(.headline)

                Button("New Game") {
                    showDifficultyDialog = true
                }
                .buttonStyle(.borderedProminent)

                Button("Continue Game") {
                    // TODO: Wire navigation to active game.
                }
                .buttonStyle(.bordered)
                .disabled(!viewModel.canContinue)

                NavigationLink("Shop") {
                    ShopView()
                }

                if viewModel.isGeneratingPuzzle {
                    ProgressView(viewModel.isRegeneratingPuzzle ? "Regenerating puzzle…" : "Generating puzzle…")
                        .padding(.top, 8)
                }
            }
            .padding()
            .confirmationDialog("Choose Difficulty", isPresented: $showDifficultyDialog) {
                ForEach(Difficulty.allCases) { difficulty in
                    Button(difficulty.displayName) {
                        Task {
                            activeSnapshot = await viewModel.startNewGame(difficulty: difficulty)
                        }
                    }
                }
                Button("Cancel", role: .cancel) {}
            }
            .navigationDestination(item: $activeSnapshot) { snapshot in
                GameView(
                    viewModel: GameViewModel(
                        snapshot: snapshot,
                        persistence: GamePersistenceService()
                    )
                )
            }
            .toolbar {
                NavigationLink {
                    SettingsView(viewModel: SettingsViewModel(settingsService: SettingsService()))
                } label: {
                    Image(systemName: "gearshape")
                }
            }
        }
    }
}
#endif
