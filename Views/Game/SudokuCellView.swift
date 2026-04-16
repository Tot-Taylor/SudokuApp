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
                .frame(maxWidth: .infinity, minHeight: 38)
                .fontWeight(cell.givenValue == nil ? .regular : .semibold)
                .foregroundColor(cell.givenValue == nil ? .primary : .blue)
                .background(backgroundColor)
                .overlay(alignment: .top) {
                    Rectangle()
                        .fill(gridLineColor)
                        .frame(height: topLineWidth)
                }
                .overlay(alignment: .leading) {
                    Rectangle()
                        .fill(gridLineColor)
                        .frame(width: leftLineWidth)
                }
                .overlay(alignment: .bottom) {
                    Rectangle()
                        .fill(gridLineColor)
                        .frame(height: bottomLineWidth)
                }
                .overlay(alignment: .trailing) {
                    Rectangle()
                        .fill(gridLineColor)
                        .frame(width: rightLineWidth)
                }
                .overlay {
                    Rectangle()
                        .stroke(borderColor, lineWidth: isSelected ? 2 : 0)
                        .padding(1)
                }
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
        isSelected ? .orange : .clear
    }

    private var gridLineColor: Color {
        Color.black.opacity(0.35)
    }

    private var topLineWidth: CGFloat {
        cell.row % 3 == 0 ? 2 : 0.75
    }

    private var leftLineWidth: CGFloat {
        cell.col % 3 == 0 ? 2 : 0.75
    }

    private var bottomLineWidth: CGFloat {
        if cell.row == 8 { return 2 }
        return (cell.row + 1) % 3 == 0 ? 2 : 0.75
    }

    private var rightLineWidth: CGFloat {
        if cell.col == 8 { return 2 }
        return (cell.col + 1) % 3 == 0 ? 2 : 0.75
    }
}
#endif
