import AppKit
import SwiftUI

struct FavoriteDirectoriesView: View {
    @ObservedObject var viewModel: AppViewModel
    @State private var selection: FavoriteDirectory.ID?

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 26) {
                HeaderView(
                    icon: "heart.fill",
                    accent: Color(red: 1.0, green: 0.35, blue: 0.48),
                    title: viewModel.strings.favoriteDirectoriesTitle,
                    subtitle: viewModel.strings.favoriteDirectoriesSubtitle
                )

                AppPanel {
                    VStack(spacing: 0) {
                        tableHeader

                        Divider().overlay(Color.white.opacity(0.08))

                        if viewModel.favoriteDirectories.isEmpty {
                            emptyState
                        } else {
                            LazyVStack(spacing: 0) {
                                ForEach(viewModel.favoriteDirectories) { directory in
                                    FavoriteDirectoryRow(
                                        directory: directory,
                                        isSelected: selection == directory.id
                                    )
                                    .contentShape(Rectangle())
                                    .onTapGesture {
                                        selection = directory.id
                                    }

                                    Divider().overlay(Color.white.opacity(0.05))
                                }
                            }
                        }
                    }
                }

                HStack(spacing: 12) {
                    roundedActionButton(systemImage: "plus") {
                        chooseFavoriteDirectory()
                    }

                    roundedActionButton(systemImage: "minus") {
                        viewModel.removeFavoriteDirectory(id: selection)
                        selection = nil
                    }
                    .disabled(selection == nil)

                    Spacer()

                    Button(viewModel.strings.resetDefaults) {
                        viewModel.reload()
                    }
                    .buttonStyle(AppCapsuleButtonStyle())
                }

                HStack(spacing: 120) {
                    Toggle(isOn: Binding(
                        get: { viewModel.showMenuIcons },
                        set: { viewModel.setShowMenuIcons($0) }
                    )) {
                        Text(viewModel.strings.showIcons)
                    }
                    .toggleStyle(.checkbox)
                    .foregroundStyle(.white.opacity(0.92))

                    Toggle(isOn: Binding(
                        get: { viewModel.favoriteDirectoriesEnabled },
                        set: { viewModel.setFavoriteDirectoriesEnabled($0) }
                    )) {
                        Text(viewModel.strings.enableFavoriteDirectories)
                    }
                    .toggleStyle(.checkbox)
                    .foregroundStyle(.white.opacity(0.92))
                }

                statusText
            }
            .padding(.horizontal, 36)
            .padding(.vertical, 34)
        }
    }

    private var tableHeader: some View {
        HStack(spacing: 0) {
            headerCell(viewModel.strings.iconColumnTitle, width: 96)
            headerCell(viewModel.strings.realPathColumnTitle, width: 1, alignment: .leading)
            headerCell(viewModel.strings.displayNameColumnTitle, width: 420, alignment: .leading)
        }
        .padding(.horizontal, 18)
        .padding(.vertical, 14)
        .background(Color.white.opacity(0.03))
    }

    private func headerCell(_ title: String, width: CGFloat, alignment: Alignment = .center) -> some View {
        Text(title)
            .font(.system(size: 16, weight: .bold))
            .foregroundStyle(.white.opacity(0.94))
            .frame(maxWidth: width == 1 ? .infinity : width, alignment: alignment)
    }

    private var emptyState: some View {
        VStack(spacing: 14) {
            Spacer(minLength: 56)
            Image(systemName: "folder.badge.plus")
                .font(.system(size: 42, weight: .semibold))
                .foregroundStyle(.white.opacity(0.38))
            Text(viewModel.strings.noFavoriteDirectories)
                .font(.system(size: 18, weight: .semibold))
                .foregroundStyle(.white.opacity(0.76))
            Text(viewModel.strings.favoriteDirectoriesEmptyHint)
                .font(.system(size: 15, weight: .medium))
                .foregroundStyle(.white.opacity(0.46))
            Spacer(minLength: 56)
        }
        .frame(maxWidth: .infinity)
    }

    private var statusText: some View {
        HStack {
            Spacer()
            Text(viewModel.statusMessage)
                .font(.system(size: 13, weight: .medium))
                .foregroundStyle(.white.opacity(0.58))
        }
    }

    private func roundedActionButton(systemImage: String, action: @escaping () -> Void) -> some View {
        Button(action: action) {
            Image(systemName: systemImage)
                .font(.system(size: 18, weight: .bold))
                .frame(width: 44, height: 44)
        }
        .buttonStyle(AppSmallSquareButtonStyle())
    }

    private func chooseFavoriteDirectory() {
        let panel = NSOpenPanel()
        panel.canChooseFiles = false
        panel.canChooseDirectories = true
        panel.allowsMultipleSelection = false
        panel.prompt = viewModel.strings.addDirectory

        if panel.runModal() == .OK, let url = panel.url {
            viewModel.addFavoriteDirectory(url)
            selection = viewModel.favoriteDirectories.last?.id
        }
    }
}

private struct FavoriteDirectoryRow: View {
    let directory: FavoriteDirectory
    let isSelected: Bool

    var body: some View {
        HStack(spacing: 0) {
            Image(nsImage: RightKitIconProvider.directoryIcon(for: directory.url, size: 32))
                .resizable()
                .interpolation(.high)
                .frame(width: 32, height: 32)
                .frame(width: 96)

            Text(directory.path)
                .font(.system(size: 19, weight: .semibold))
                .foregroundStyle(.white.opacity(0.86))
                .frame(maxWidth: .infinity, alignment: .leading)

            Text(directory.name)
                .font(.system(size: 19, weight: .semibold))
                .foregroundStyle(.white.opacity(0.86))
                .frame(width: 420, alignment: .leading)
        }
        .padding(.horizontal, 18)
        .padding(.vertical, 16)
        .background(isSelected ? Color.white.opacity(0.08) : Color.clear)
    }
}
