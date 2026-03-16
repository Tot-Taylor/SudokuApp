import Foundation

enum Difficulty: String, Codable, CaseIterable, Identifiable {
    case easy
    case medium
    case hard
    case expert

    var id: String { rawValue }

    var displayName: String {
        rawValue.capitalized
    }
}

struct DifficultyReward {
    static func points(for difficulty: Difficulty) -> Int {
        switch difficulty {
        case .easy: return 1
        case .medium: return 5
        case .hard: return 10
        case .expert: return 25
        }
    }
}

enum GameEndReason: String, Codable {
    case solved
    case gaveUp
    case outOfLives
}

enum TileOrigin: String, Codable {
    case given
    case user
    case hint
}
