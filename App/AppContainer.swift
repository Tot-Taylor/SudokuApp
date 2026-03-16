import Foundation

final class AppContainer {
    let settingsService: SettingsServiceProtocol
    let gamePersistenceService: GamePersistenceServiceProtocol
    let puzzleGenerator: PuzzleGenerationServiceProtocol
    let statsService: StatsService
    let themeService: ThemeService

    init(
        settingsService: SettingsServiceProtocol = SettingsService(),
        gamePersistenceService: GamePersistenceServiceProtocol = GamePersistenceService(),
        puzzleGenerator: PuzzleGenerationServiceProtocol = PuzzleGenerationService(),
        statsService: StatsService = StatsService(),
        themeService: ThemeService = ThemeService()
    ) {
        self.settingsService = settingsService
        self.gamePersistenceService = gamePersistenceService
        self.puzzleGenerator = puzzleGenerator
        self.statsService = statsService
        self.themeService = themeService
    }
}
