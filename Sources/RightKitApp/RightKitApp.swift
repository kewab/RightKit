import SwiftUI

enum RightKitScene {
    static let mainWindowID = "main-window"
}

@main
struct RightKitApp: App {
    @NSApplicationDelegateAdaptor(RightKitAppDelegate.self) private var appDelegate
    @StateObject private var viewModel = AppViewModel()
    @StateObject private var lifecycle = AppLifecycleCoordinator.shared

    var body: some Scene {
        Window("RightKit", id: RightKitScene.mainWindowID) {
            ContentView(viewModel: viewModel)
        }
        .windowStyle(.hiddenTitleBar)
        .windowToolbarStyle(.unifiedCompact(showsTitle: false))
        .defaultSize(width: 1260, height: 820)
        .windowResizability(.contentMinSize)

        MenuBarExtra {
            MenuBarExtraView(viewModel: viewModel, lifecycle: lifecycle)
        } label: {
            Image("MenuBarIcon")
                .renderingMode(.template)
        }
    }
}
