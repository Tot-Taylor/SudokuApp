#if canImport(SwiftUI)
import SwiftUI

struct StatCardView: View {
    let title: String
    let value: String

    var body: some View {
        VStack(alignment: .leading) {
            Text(title).font(.caption)
            Text(value).font(.headline)
        }
        .padding()
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(Color.gray.opacity(0.1))
        .clipShape(RoundedRectangle(cornerRadius: 10))
    }
}
#endif
