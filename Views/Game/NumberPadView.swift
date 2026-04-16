#if canImport(SwiftUI)
import SwiftUI

struct NumberPadView: View {
    let onNumberTap: (Int) -> Void
    let onHintTap: () -> Void
    let onEraseTap: () -> Void

    var body: some View {
        VStack(spacing: 12) {
            HStack(spacing: 12) {
                Button("Hint", action: onHintTap)
                    .buttonStyle(NumberPadButtonStyle())
                Button("Eraser", action: onEraseTap)
                    .buttonStyle(NumberPadButtonStyle())
            }
            HStack {
                ForEach(1..<10, id: \.self) { number in
                    Button("\(number)") {
                        onNumberTap(number)
                    }
                    .buttonStyle(NumberPadButtonStyle())
                }
            }
        }
    }
}

private struct NumberPadButtonStyle: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .font(.body.weight(.semibold))
            .foregroundStyle(Color.pink)
            .padding(.horizontal, 12)
            .padding(.vertical, 8)
            .background(
                RoundedRectangle(cornerRadius: 8, style: .continuous)
                    .fill(Color.pink.opacity(0.15))
            )
            .opacity(configuration.isPressed ? 0.8 : 1)
    }
}
#endif
