import Foundation

struct ThemeService {
    let availableThemes: [ThemeDefinition] = [
        ThemeDefinition(id: "default", displayName: "Classic", cost: 0, isBuiltIn: true),
        ThemeDefinition(id: "midnight", displayName: "Midnight", cost: 100, isBuiltIn: false),
        ThemeDefinition(id: "forest", displayName: "Forest", cost: 250, isBuiltIn: false)
    ]
}
