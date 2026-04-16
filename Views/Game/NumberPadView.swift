#if canImport(SwiftUI)
import SwiftUI

struct NumberPadView: View {
    let onNumberTap: (Int) -> Void
    let onEraseTap: () -> Void

    var body: some View {
        VStack(spacing: 12) {
            HStack {
                ForEach(1..<10, id: \.self) { number in
                    Button("\(number)") {
                        onNumberTap(number)
                    }
                    .buttonStyle(.bordered)
                }
            }
            Button("Eraser", action: onEraseTap)
                .buttonStyle(.bordered)
        }
    }
}
#endif
