#if canImport(SwiftUI)
import SwiftUI

struct SudokuCellView: View {
    let cell: CellState
    let onTap: () -> Void

    var body: some View {
        Button(action: onTap) {
            Text(cell.currentValue.map(String.init) ?? "")
                .frame(maxWidth: .infinity, minHeight: 34)
                .background(cell.givenValue == nil ? Color.gray.opacity(0.1) : Color.blue.opacity(0.15))
        }
        .buttonStyle(.plain)
    }
}
#endif
