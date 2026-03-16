import Foundation

protocol SettingsServiceProtocol {
    func loadSettings() -> GameSettingsTemplate
    func saveSettings(_ settings: GameSettingsTemplate)
}

final class SettingsService: SettingsServiceProtocol {
    private let defaults: UserDefaults
    private let key = "game.settings.template"

    init(defaults: UserDefaults = .standard) {
        self.defaults = defaults
    }

    func loadSettings() -> GameSettingsTemplate {
        guard let data = defaults.data(forKey: key),
              let settings = try? JSONDecoder().decode(GameSettingsTemplate.self, from: data)
        else {
            return .default
        }
        return settings
    }

    func saveSettings(_ settings: GameSettingsTemplate) {
        let data = try? JSONEncoder().encode(settings)
        defaults.set(data, forKey: key)
    }
}
