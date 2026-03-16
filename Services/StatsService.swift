import Foundation

struct StatsService {
    func awardCompletion(
        snapshot: inout SavedGameSnapshot,
        profile: inout PlayerProfile,
        stats: inout AppStats,
        hintsUsed: Int,
        undoCount: Int
    ) {
        guard !snapshot.pointsAwarded else { return }

        snapshot.pointsAwarded = true
        profile.totalPoints += DifficultyReward.points(for: snapshot.difficulty)

        stats.update(for: snapshot.difficulty) { difficultyStats in
            difficultyStats.completedCount += 1
            difficultyStats.totalTimeSeconds += snapshot.elapsedSeconds
            difficultyStats.totalHintsUsed += hintsUsed
            difficultyStats.totalUndoCount += undoCount

            if let currentBest = difficultyStats.bestTimeSeconds {
                difficultyStats.bestTimeSeconds = min(currentBest, snapshot.elapsedSeconds)
            } else {
                difficultyStats.bestTimeSeconds = snapshot.elapsedSeconds
            }
        }
    }
}
