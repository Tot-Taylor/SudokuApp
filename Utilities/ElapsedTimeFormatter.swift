import Foundation

enum ElapsedTimeFormatter {
    static func format(seconds: Int) -> String {
        let minutes = seconds / 60
        let remaining = seconds % 60
        return String(format: "%02d:%02d", minutes, remaining)
    }
}
