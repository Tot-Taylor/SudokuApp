#if canImport(SwiftUI)
import SwiftUI

struct NumberPadView: View {
    let onNumberTap: (Int) -> Void

    var body: some View {
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
#endif
