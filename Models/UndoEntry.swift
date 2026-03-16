import Foundation

enum UndoActionType: String, Codable {
    case placement
    case erase
    case hint
}

struct UndoEntry: Codable, Hashable {
    let row: Int
    let col: Int
    let previousValue: Int?
    let newValue: Int?
    let previousOrigin: TileOrigin?
    let newOrigin: TileOrigin?
    let actionType: UndoActionType
}
