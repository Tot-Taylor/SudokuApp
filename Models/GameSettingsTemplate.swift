import Foundation

struct GameSettingsTemplate: Codable, Hashable {
    var hintsPerGame: Int
    var livesPerGame: Int

    var hintsEnabled: Bool { hintsPerGame > 0 }
    var mistakeCheckingEnabled: Bool { livesPerGame > 0 }

    static let `default` = GameSettingsTemplate(hintsPerGame: 3, livesPerGame: 3)
}
