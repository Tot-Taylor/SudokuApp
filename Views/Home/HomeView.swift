#if canImport(SwiftUI)
import SwiftUI

struct HomeView: View {
    @StateObject var viewModel: HomeViewModel
    @State private var showDifficultyDialog = false
    @State private var activeGameViewModel: GameViewModel?
    @State private var isGameActive = false
    @State private var selectedDifficultyForNewGame: Difficulty?
    @State private var showOverwriteSavedGameAlert = false

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
                    if let savedSnapshot = viewModel.loadSavedGame() {
                        activeGameViewModel = GameViewModel(snapshot: savedSnapshot, persistence: GamePersistenceService())
                        isGameActive = true
                    }
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

                NavigationLink(isActive: $isGameActive) {
                    if let activeGameViewModel {
                        GameView(viewModel: activeGameViewModel)
                    } else {
                        EmptyView()
                    }
                } label: {
                    EmptyView()
                }
                .hidden()
            }
            .padding()
            .onAppear {
                viewModel.refresh()
            }
            .confirmationDialog("Choose Difficulty", isPresented: $showDifficultyDialog) {
                ForEach(Difficulty.allCases) { difficulty in
                    Button(difficulty.displayName) {
                        if viewModel.canContinue {
                            selectedDifficultyForNewGame = difficulty
                            showOverwriteSavedGameAlert = true
                        } else {
                            Task {
                                let snapshot = await viewModel.startNewGame(difficulty: difficulty)
                                activeGameViewModel = GameViewModel(snapshot: snapshot, persistence: GamePersistenceService())
                                isGameActive = true
                            }
                        }
                    }
                }
                Button("Cancel", role: .cancel) {}
            }
            .alert("Start New Puzzle?", isPresented: $showOverwriteSavedGameAlert, presenting: selectedDifficultyForNewGame) { difficulty in
                Button("Cancel", role: .cancel) {}
                Button("Start New", role: .destructive) {
                    Task {
                        let snapshot = await viewModel.startNewGame(difficulty: difficulty)
                        activeGameViewModel = GameViewModel(snapshot: snapshot, persistence: GamePersistenceService())
                        isGameActive = true
                    }
                }
            } message: { _ in
                Text("Starting a new puzzle will overwrite your existing saved puzzle.")
            }
            .alert("Unable to Restore Saved Game", isPresented: Binding(
                get: { viewModel.restoreErrorMessage != nil },
                set: { isPresented in
                    if !isPresented {
                        viewModel.clearRestoreError()
                    }
                }
            )) {
                Button("OK", role: .cancel) {
                    viewModel.clearRestoreError()
                }
            } message: {
                Text(viewModel.restoreErrorMessage ?? "")
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
