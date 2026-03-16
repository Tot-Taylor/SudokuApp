import Foundation

struct DifficultyStats: Codable {
    var completedCount: Int
    var bestTimeSeconds: Int?
    var totalTimeSeconds: Int
    var totalHintsUsed: Int
    var totalUndoCount: Int

    var averageTimeSeconds: Double {
        guard completedCount > 0 else { return 0 }
        return Double(totalTimeSeconds) / Double(completedCount)
    }

    static let zero = DifficultyStats(completedCount: 0, bestTimeSeconds: nil, totalTimeSeconds: 0, totalHintsUsed: 0, totalUndoCount: 0)
}

struct AppStats: Codable {
    var easy: DifficultyStats
    var medium: DifficultyStats
    var hard: DifficultyStats
    var expert: DifficultyStats

    static let zero = AppStats(easy: .zero, medium: .zero, hard: .zero, expert: .zero)

    mutating func update(for difficulty: Difficulty, _ mutate: (inout DifficultyStats) -> Void) {
        switch difficulty {
        case .easy: mutate(&easy)
        case .medium: mutate(&medium)
        case .hard: mutate(&hard)
        case .expert: mutate(&expert)
        }
    }
}
