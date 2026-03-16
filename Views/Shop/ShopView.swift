#if canImport(SwiftUI)
import SwiftUI

struct ShopView: View {
    var body: some View {
        VStack(spacing: 12) {
            Text("Shop")
                .font(.title.bold())
            Text("Coming later")
            Text("Points will be used to unlock themes in a future release.")
                .font(.footnote)
                .foregroundStyle(.secondary)
                .multilineTextAlignment(.center)
        }
        .padding()
    }
}
#endif
