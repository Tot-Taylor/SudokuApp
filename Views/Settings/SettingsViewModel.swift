#if canImport(Combine)
import Foundation
import Combine

@MainActor
final class SettingsViewModel: ObservableObject {
    @Published var hintsPerGame: Int = 3
    @Published var livesPerGame: Int = 3

    private let settingsService: SettingsServiceProtocol

    init(settingsService: SettingsServiceProtocol) {
        self.settingsService = settingsService
        let settings = settingsService.loadSettings()
        hintsPerGame = settings.hintsPerGame
        livesPerGame = settings.livesPerGame
    }

    func save() {
        settingsService.saveSettings(GameSettingsTemplate(hintsPerGame: hintsPerGame, livesPerGame: livesPerGame))
    }
}
#endif
