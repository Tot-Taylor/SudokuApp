#if canImport(SwiftUI)
import SwiftUI

struct HomeView: View {
    @StateObject var viewModel: HomeViewModel
    @State private var showDifficultyDialog = false

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
            }
            .padding()
            .confirmationDialog("Choose Difficulty", isPresented: $showDifficultyDialog) {
                ForEach(Difficulty.allCases) { difficulty in
                    Button(difficulty.displayName) {
                        _ = viewModel.startNewGame(difficulty: difficulty)
                    }
                }
                Button("Cancel", role: .cancel) {}
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
