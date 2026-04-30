import SwiftUI

struct StatusView: View {
    @ObservedObject var viewModel: AppViewModel

    var body: some View {
        VStack(alignment: .leading, spacing: 18) {
            HeaderView(
                title: "RightKit Status",
                subtitle: "Host app is ready. Finder menu wiring comes from the extension target."
            )

            InfoRow(label: "App Group", value: AppGroup.identifier)
            InfoRow(label: "Favorite Directories", value: "\(viewModel.favoriteDirectories.count)")
            InfoRow(label: "File Templates", value: "\(viewModel.fileTemplates.count)")
            InfoRow(label: "Cut Items", value: "\(viewModel.cutPasteState?.sourcePaths.count ?? 0)")

            HStack {
                Button {
                    viewModel.reload()
                } label: {
                    Label("Reload Shared State", systemImage: "arrow.clockwise")
                }

                Button {
                    viewModel.clearCutPasteState()
                } label: {
                    Label("Clear Cut State", systemImage: "xmark.circle")
                }
                .disabled(viewModel.cutPasteState == nil)

                Spacer()
            }

            Spacer()
        }
        .padding(24)
    }
}
