#if canImport(SwiftUI)
import SwiftUI

@main
struct SudokuApp: App {
    @State private var container = AppContainer()

    var body: some Scene {
        WindowGroup {
            HomeView(viewModel: HomeViewModel(container: container))
        }
    }
}
#endif
