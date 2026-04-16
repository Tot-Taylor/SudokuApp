import Foundation

protocol DifficultyAnalysisServiceProtocol {
    func classify(board: [[Int?]]) -> Difficulty
}

/// V1 heuristic: bucket by clue count as a temporary approximation.
/// Replaced later with human-technique based analyzer.
struct DifficultyAnalysisService: DifficultyAnalysisServiceProtocol {
    func classify(board: [[Int?]]) -> Difficulty {
        let clues = board.flatMap { $0 }.compactMap { $0 }.count
        switch clues {
        case 40...81: return .easy
        case 33..<40: return .medium
        case 28..<33: return .hard
        default: return .expert
        }
    }
}
