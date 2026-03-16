import Foundation

struct PlayerProfile: Codable {
    var totalPoints: Int
    var activeThemeID: String
    var ownedThemeIDs: Set<String>

    static let `default` = PlayerProfile(totalPoints: 0, activeThemeID: "default", ownedThemeIDs: ["default"])
}
