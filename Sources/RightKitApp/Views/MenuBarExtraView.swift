import SwiftUI

struct MenuBarExtraView: View {
    @ObservedObject var viewModel: AppViewModel
    @ObservedObject var lifecycle: AppLifecycleCoordinator
    @Environment(\.openWindow) private var openWindow

    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            VStack(alignment: .leading, spacing: 4) {
                Text("RightKit")
                    .font(.system(size: 14, weight: .semibold))

                Text(lifecycle.isMenuBarOnly ? viewModel.strings.menuBarStatus : viewModel.strings.finderContextMenuStatus)
                    .font(.system(size: 11, weight: .medium))
                    .foregroundStyle(.secondary)
            }

            Button(viewModel.strings.openMainWindow) {
                lifecycle.revealMainWindow()
                openWindow(id: RightKitScene.mainWindowID)
            }

            Divider()

            Button(viewModel.strings.quitApp) {
                lifecycle.requestTermination()
            }
        }
        .padding(12)
        .frame(width: 240, alignment: .leading)
    }
}
