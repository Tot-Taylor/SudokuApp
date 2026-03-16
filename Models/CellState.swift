import Foundation

struct CellState: Codable, Hashable, Identifiable {
    let row: Int
    let col: Int
    let solutionValue: Int
    let givenValue: Int?
    var currentValue: Int?
    var origin: TileOrigin?

    var id: String { "\(row)-\(col)" }

    var isEditable: Bool {
        givenValue == nil
    }
}
