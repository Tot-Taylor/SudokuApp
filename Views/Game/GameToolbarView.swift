#if canImport(SwiftUI)
import SwiftUI

struct GameToolbarView: View {
    let onBack: () -> Void

    var body: some View {
        HStack {
            Button("Back", action: onBack)
            Spacer()
        }
    }
}
#endif
