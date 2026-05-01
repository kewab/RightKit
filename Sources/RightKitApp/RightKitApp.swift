import SwiftUI

@main
struct RightKitApp: App {
    var body: some Scene {
        WindowGroup {
            ContentView()
        }
        .windowStyle(.hiddenTitleBar)
        .windowToolbarStyle(.unifiedCompact(showsTitle: false))
        .defaultSize(width: 1260, height: 820)
        .windowResizability(.contentMinSize)
    }
}
