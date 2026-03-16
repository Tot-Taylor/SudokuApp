#if canImport(SwiftUI)
import SwiftUI

struct SettingsView: View {
    @StateObject var viewModel: SettingsViewModel

    var body: some View {
        Form {
            Stepper("Hints per game: \(viewModel.hintsPerGame)", value: $viewModel.hintsPerGame, in: 0...10)
            Stepper("Lives per game: \(viewModel.livesPerGame)", value: $viewModel.livesPerGame, in: 0...10)

            Text("0 hints = hints disabled")
            Text("0 lives = wrong move checking disabled")
            Text("Changes apply to new games only")
                .font(.footnote)
                .foregroundStyle(.secondary)
        }
        .navigationTitle("Settings")
        .onDisappear {
            viewModel.save()
        }
    }
}
#endif
