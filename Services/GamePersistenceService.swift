import Foundation

protocol GamePersistenceServiceProtocol {
    func load() -> SavedGameSnapshot?
    func save(_ snapshot: SavedGameSnapshot)
    func clear()
}

final class GamePersistenceService: GamePersistenceServiceProtocol {
    private let defaults: UserDefaults
    private let key = "saved.game.snapshot"

    init(defaults: UserDefaults = .standard) {
        self.defaults = defaults
    }

    func load() -> SavedGameSnapshot? {
        guard let data = defaults.data(forKey: key) else { return nil }
        return try? JSONDecoder().decode(SavedGameSnapshot.self, from: data)
    }

    func save(_ snapshot: SavedGameSnapshot) {
        let data = try? JSONEncoder().encode(snapshot)
        defaults.set(data, forKey: key)
    }

    func clear() {
        defaults.removeObject(forKey: key)
    }
}
