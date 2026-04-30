import AppKit
import SwiftUI

struct FavoriteDirectoriesView: View {
    @ObservedObject var viewModel: AppViewModel

    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            HeaderView(
                title: viewModel.strings.favoriteDirectoriesTitle,
                subtitle: viewModel.strings.favoriteDirectoriesSubtitle
            )

            List {
                if viewModel.favoriteDirectories.isEmpty {
                    Text(viewModel.strings.noFavoriteDirectories)
                        .foregroundStyle(.secondary)
                } else {
                    ForEach(viewModel.favoriteDirectories) { directory in
                        VStack(alignment: .leading, spacing: 4) {
                            Text(directory.name)
                                .font(.headline)
                            Text(directory.path)
                                .font(.caption)
                                .foregroundStyle(.secondary)
                                .lineLimit(1)
                        }
                        .padding(.vertical, 4)
                    }
                    .onDelete(perform: viewModel.removeFavoriteDirectories)
                }
            }
            .listStyle(.inset)

            HStack {
                Button {
                    chooseFavoriteDirectory()
                } label: {
                    Label(viewModel.strings.addDirectory, systemImage: "plus")
                }

                Button {
                    viewModel.reload()
                } label: {
                    Label(viewModel.strings.reload, systemImage: "arrow.clockwise")
                }

                Spacer()

                Text(viewModel.statusMessage)
                    .font(.caption)
                    .foregroundStyle(.secondary)
            }
        }
        .padding(24)
    }

    private func chooseFavoriteDirectory() {
        let panel = NSOpenPanel()
        panel.canChooseFiles = false
        panel.canChooseDirectories = true
        panel.allowsMultipleSelection = false
        panel.prompt = viewModel.strings.addDirectory

        if panel.runModal() == .OK, let url = panel.url {
            viewModel.addFavoriteDirectory(url)
        }
    }
}
