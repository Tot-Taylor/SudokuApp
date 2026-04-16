#if canImport(SwiftUI)
import SwiftUI

struct SudokuCellView: View {
    let cell: CellState
    let isSelected: Bool
    let isInSelectedBand: Bool
    let onTap: () -> Void

    var body: some View {
        Button(action: onTap) {
            Text(displayText)
                .frame(maxWidth: .infinity, minHeight: 38)
                .font(displayFont)
                .fontWeight(cell.givenValue == nil ? .regular : .semibold)
                .foregroundColor(cell.givenValue == nil ? .primary : .pink)
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
            return selectedMagenta.opacity(0.35)
        }
        if isInSelectedBand {
            return selectedMagenta.opacity(0.15)
        }
        if cell.givenValue == nil, cell.currentValue != nil {
            return selectedMagenta.opacity(0.2)
        }
        if cell.givenValue == nil {
            return Color.yellow.opacity(0.12)
        }
        return Color.pink.opacity(0.15)
    }

    private var displayText: String {
        cell.currentValue.map(String.init) ?? "♥"
    }

    private var displayFont: Font {
        if cell.currentValue == nil {
            return .system(size: 12, weight: .semibold)
        }
        return .body
    }

    private var borderColor: Color {
        isSelected ? selectedMagenta : .clear
    }

    private var selectedMagenta: Color {
        Color(red: 1.0, green: 0.0, blue: 1.0)
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
