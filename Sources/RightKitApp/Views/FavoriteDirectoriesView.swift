import SwiftUI
import UniformTypeIdentifiers

struct FavoriteDirectoriesView: View {
    @ObservedObject var viewModel: AppViewModel
    @State private var selection: FavoriteDirectory.ID?
    @State private var isDirectoryImporterPresented = false

    var body: some View {
        SettingsPage(
            title: viewModel.strings.favoriteDirectoriesTitle,
            subtitle: viewModel.strings.favoriteDirectoriesSubtitle,
            iconStyle: .favorites
        ) {
            SettingsGroup(title: viewModel.strings.favoriteDirectoriesTitle) {
                if viewModel.favoriteDirectories.isEmpty {
                    SettingsEmptyState(
                        title: viewModel.strings.noFavoriteDirectories,
                        subtitle: viewModel.strings.favoriteDirectoriesEmptyHint,
                        systemImage: "folder.badge.plus"
                    )
                } else {
                    ForEach(Array(viewModel.favoriteDirectories.enumerated()), id: \.element.id) { index, directory in
                        FavoriteDirectoryRow(
                            directory: directory,
                            isSelected: selection == directory.id
                        )
                        .contentShape(Rectangle())
                        .onTapGesture {
                            selection = directory.id
                        }

                        if index < viewModel.favoriteDirectories.count - 1 {
                            SettingsDivider()
                        }
                    }
                }
            }

            HStack(spacing: 10) {
                Button {
                    isDirectoryImporterPresented = true
                } label: {
                    Label(viewModel.strings.addDirectory, systemImage: "plus")
                }
                .buttonStyle(AppCapsuleButtonStyle())

                Button {
                    viewModel.removeFavoriteDirectory(id: selection)
                    selection = nil
                } label: {
                    Image(systemName: "minus")
                        .font(.system(size: 14, weight: .bold))
                }
                .buttonStyle(AppSmallSquareButtonStyle())
                .disabled(selection == nil)

                Button(viewModel.strings.resetDefaults) {
                    viewModel.reload()
                    selection = nil
                }
                .buttonStyle(AppCapsuleButtonStyle())

                Spacer()
            }

            SettingsGroup(title: viewModel.strings.launchAndDisplayTitle) {
                FavoriteToggleRow(
                    title: viewModel.strings.showIcons,
                    isOn: Binding(
                        get: { viewModel.showMenuIcons },
                        set: { viewModel.setShowMenuIcons($0) }
                    )
                )

                SettingsDivider()

                FavoriteToggleRow(
                    title: viewModel.strings.enableFavoriteDirectories,
                    isOn: Binding(
                        get: { viewModel.favoriteDirectoriesEnabled },
                        set: { viewModel.setFavoriteDirectoriesEnabled($0) }
                    )
                )
            }

            HStack {
                Spacer()
                Text(viewModel.statusMessage)
                    .font(.system(size: 12, weight: .medium))
                    .foregroundStyle(AppTheme.tertiaryText)
            }
            .padding(.top, 2)
        }
        .fileImporter(
            isPresented: $isDirectoryImporterPresented,
            allowedContentTypes: [.folder],
            allowsMultipleSelection: false
        ) { result in
            guard case .success(let urls) = result, let url = urls.first else {
                return
            }
            viewModel.addFavoriteDirectory(url)
            selection = viewModel.favoriteDirectories.last?.id
        }
    }
}

private struct FavoriteDirectoryRow: View {
    let directory: FavoriteDirectory
    let isSelected: Bool

    var body: some View {
        HStack(spacing: 12) {
            Image(nsImage: RightKitIconProvider.directoryIcon(for: directory.url, size: 24))
                .resizable()
                .interpolation(.high)
                .frame(width: 24, height: 24)

            VStack(alignment: .leading, spacing: 2) {
                Text(directory.name)
                    .font(.system(size: 15, weight: .semibold))
                    .foregroundStyle(AppTheme.primaryText)
                Text(directory.path)
                    .font(.system(size: 12, weight: .medium))
                    .foregroundStyle(AppTheme.tertiaryText)
                    .lineLimit(1)
                    .truncationMode(.middle)
            }

            Spacer()

            if isSelected {
                Image(systemName: "checkmark.circle.fill")
                    .font(.system(size: 15, weight: .semibold))
                    .foregroundStyle(AppTheme.accent)
            }
        }
        .padding(.horizontal, 16)
        .padding(.vertical, 10)
        .background(isSelected ? AppTheme.selectedFill : Color.clear)
    }
}

private struct FavoriteToggleRow: View {
    let title: String
    @Binding var isOn: Bool

    var body: some View {
        HStack(spacing: 12) {
            Text(title)
                .font(.system(size: 15, weight: .semibold))
                .foregroundStyle(AppTheme.primaryText)
            Spacer()
            Toggle("", isOn: $isOn)
                .labelsHidden()
        }
        .padding(.horizontal, 16)
        .padding(.vertical, 12)
    }
}
