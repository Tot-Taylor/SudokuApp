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
                    .buttonStyle(.borderedProminent)
                Button("Eraser", action: onEraseTap)
                    .buttonStyle(.bordered)
            }
            HStack {
                ForEach(1..<10, id: \.self) { number in
                    Button("\(number)") {
                        onNumberTap(number)
                    }
                    .buttonStyle(.bordered)
                }
            }
        }
    }
}
#endif
