#if canImport(SwiftUI)
import SwiftUI

struct HomeView: View {
    @StateObject var viewModel: HomeViewModel
    @State private var showDifficultyDialog = false
    @State private var activeGameViewModel: GameViewModel?

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
                .disabled(viewModel.isGenerating)

                Button("Continue Game") {
                    // TODO: Wire navigation to active game.
                }
                .buttonStyle(.bordered)
                .disabled(!viewModel.canContinue)

                NavigationLink("Shop") {
                    ShopView()
                }

                if viewModel.isGenerating {
                    ProgressView()
                }
                if viewModel.isRegenerating {
                    Text("Regenerating puzzle…")
                        .font(.footnote)
                        .foregroundStyle(.secondary)
                }
            }
            .padding()
            .confirmationDialog("Choose Difficulty", isPresented: $showDifficultyDialog) {
                ForEach(Difficulty.allCases) { difficulty in
                    Button(difficulty.displayName) {
                        Task {
                            let snapshot = await viewModel.startNewGame(difficulty: difficulty)
                            activeGameViewModel = GameViewModel(snapshot: snapshot, persistence: GamePersistenceService())
                        }
                    }
                }
                Button("Cancel", role: .cancel) {}
            }
            .navigationDestination(item: $activeGameViewModel) { gameViewModel in
                GameView(viewModel: gameViewModel)
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
