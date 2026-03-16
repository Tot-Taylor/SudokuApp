import Foundation

struct ThemeDefinition: Codable, Identifiable, Hashable {
    let id: String
    let displayName: String
    let cost: Int
    let isBuiltIn: Bool
}
