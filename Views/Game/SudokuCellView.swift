#if canImport(SwiftUI)
import SwiftUI

struct SudokuCellView: View {
    let cell: CellState
    let isSelected: Bool
    let isInSelectedBand: Bool
    let onTap: () -> Void

    var body: some View {
        Button(action: onTap) {
            Text(cell.currentValue.map(String.init) ?? "·")
                .frame(maxWidth: .infinity, minHeight: 34)
                .fontWeight(cell.givenValue == nil ? .regular : .semibold)
                .foregroundStyle(cell.givenValue == nil ? .primary : .blue)
                .background(backgroundColor)
                .overlay(
                    RoundedRectangle(cornerRadius: 4)
                        .stroke(borderColor, lineWidth: isSelected ? 2 : 1)
                )
        }
        .buttonStyle(.plain)
        .disabled(!cell.isEditable)
    }

    private var backgroundColor: Color {
        if isSelected {
            return Color.orange.opacity(0.35)
        }
        if isInSelectedBand {
            return Color.orange.opacity(0.15)
        }
        if cell.givenValue == nil {
            return Color.gray.opacity(0.1)
        }
        return Color.blue.opacity(0.15)
    }

    private var borderColor: Color {
        if isSelected {
            return .orange
        }
        return Color.gray.opacity(0.25)
    }
}
#endif
