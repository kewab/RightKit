import SwiftUI

struct ContentView: View {
    @StateObject private var viewModel = AppViewModel()
    @State private var selection: SidebarSection = .general

    var body: some View {
        ZStack {
            AppBackgroundView()

            HStack(spacing: 20) {
                AppSidebar(selection: $selection, strings: viewModel.strings)

                VStack(spacing: 16) {
                    AppFloatingToolbar(
                        title: selection.title(strings: viewModel.strings),
                        subtitle: selection.subtitle(strings: viewModel.strings),
                        language: viewModel.language.displayName,
                        status: viewModel.statusMessage
                    )

                    contentView
                        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .topLeading)
                }
                .padding(.vertical, 20)
                .padding(.trailing, 20)
            }
            .padding(.leading, 20)
        }
        .frame(minWidth: 1180, minHeight: 780)
        .preferredColorScheme(.light)
    }

    @ViewBuilder
    private var contentView: some View {
        switch selection {
        case .general:
            GeneralSettingsView(viewModel: viewModel)
        case .newFile:
            FileTemplatesView(viewModel: viewModel)
        case .favorites:
            FavoriteDirectoriesView(viewModel: viewModel)
        }
    }
}

enum SidebarSection: String, CaseIterable, Identifiable {
    case general
    case newFile
    case favorites

    var id: String { rawValue }

    func title(strings: RightKitStrings) -> String {
        switch self {
        case .general:
            strings.generalSettingsTitle
        case .newFile:
            strings.templatesTab
        case .favorites:
            strings.favoriteDirectoriesTitle
        }
    }

    func subtitle(strings: RightKitStrings) -> String {
        switch self {
        case .general:
            strings.generalSettingsSubtitle
        case .newFile:
            strings.templatesSubtitle
        case .favorites:
            strings.favoriteDirectoriesSubtitle
        }
    }
}

private struct AppSidebar: View {
    @Binding var selection: SidebarSection
    let strings: RightKitStrings

    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            VStack(alignment: .leading, spacing: 16) {
                AppBrandBadge()

                VStack(alignment: .leading, spacing: 4) {
                    Text("RightKit")
                        .font(.system(size: 22, weight: .semibold))
                        .foregroundStyle(AppTheme.primaryText)

                    Text("Finder extension toolkit")
                        .font(.system(size: 13, weight: .medium))
                        .foregroundStyle(AppTheme.secondaryText)
                }
            }
            .padding(.horizontal, 20)
            .padding(.top, 24)
            .padding(.bottom, 20)

            VStack(spacing: 8) {
                ForEach(sidebarItems(strings: strings)) { item in
                    SidebarButton(
                        item: item,
                        isSelected: item.section == selection
                    ) {
                        selection = item.section
                    }
                }
            }
            .padding(.horizontal, 12)

            Spacer()
        }
        .frame(width: 276)
        .background(
            AppSidebarMaterial()
        )
        .clipShape(RoundedRectangle(cornerRadius: 12, style: .continuous))
        .overlay {
            RoundedRectangle(cornerRadius: 12, style: .continuous)
                .stroke(AppTheme.divider, lineWidth: 1)
        }
        .shadow(color: AppTheme.shadow, radius: 20, y: 10)
    }

    private func sidebarItems(strings: RightKitStrings) -> [SidebarItem] {
        [
            SidebarItem(
                section: .general,
                title: strings.generalSettingsTitle,
                icon: "gearshape.fill",
                accent: Color(red: 0.13, green: 0.69, blue: 0.98)
            ),
            SidebarItem(
                section: .newFile,
                title: strings.templatesTab,
                icon: "doc.badge.plus",
                accent: Color(red: 0.40, green: 0.84, blue: 0.95)
            ),
            SidebarItem(
                section: .favorites,
                title: strings.favoriteDirectoriesTitle,
                icon: "heart.fill",
                accent: Color(red: 1.0, green: 0.36, blue: 0.48)
            )
        ]
    }
}

private struct SidebarItem: Identifiable {
    let section: SidebarSection
    let title: String
    let icon: String
    let accent: Color

    var id: SidebarSection { section }
}

private struct SidebarButton: View {
    let item: SidebarItem
    let isSelected: Bool
    let action: () -> Void
    @State private var isHovered = false

    var body: some View {
        Button(action: action) {
            HStack(spacing: 12) {
                ZStack {
                    RoundedRectangle(cornerRadius: 10, style: .continuous)
                        .fill(
                            LinearGradient(
                                colors: [
                                    item.accent.opacity(0.98),
                                    item.accent.opacity(0.72)
                                ],
                                startPoint: .topLeading,
                                endPoint: .bottomTrailing
                            )
                        )
                    Image(systemName: item.icon)
                        .font(.system(size: 16, weight: .semibold))
                        .foregroundStyle(.white)
                }
                .frame(width: 36, height: 36)

                Text(item.title)
                    .font(.system(size: 15, weight: .semibold))
                    .foregroundStyle(AppTheme.primaryText)

                Spacer()
            }
            .padding(.horizontal, 14)
            .frame(height: 48)
            .background(
                RoundedRectangle(cornerRadius: 10, style: .continuous)
                    .fill(backgroundFill)
            )
            .overlay {
                RoundedRectangle(cornerRadius: 10, style: .continuous)
                    .stroke(isSelected ? AppTheme.selectedStroke : Color.clear, lineWidth: 1)
            }
        }
        .buttonStyle(.plain)
        .onHover { hovered in
            isHovered = hovered
        }
    }

    private var backgroundFill: Color {
        if isSelected {
            return AppTheme.selectedFill
        }
        if isHovered {
            return AppTheme.hoverFill
        }
        return .clear
    }
}

private struct AppBrandBadge: View {
    var body: some View {
        RoundedRectangle(cornerRadius: 22, style: .continuous)
            .fill(
                LinearGradient(
                    colors: [
                        Color.white.opacity(0.96),
                        Color(red: 0.93, green: 0.97, blue: 1.0)
                    ],
                    startPoint: .topLeading,
                    endPoint: .bottomTrailing
                )
            )
            .overlay {
                Text("R")
                    .font(.system(size: 50, weight: .bold, design: .rounded))
                    .foregroundStyle(
                        LinearGradient(
                            colors: [
                                Color(red: 0.31, green: 0.56, blue: 0.98),
                                Color(red: 0.84, green: 0.35, blue: 0.84)
                            ],
                            startPoint: .topLeading,
                            endPoint: .bottomTrailing
                        )
                    )
            }
            .frame(width: 92, height: 92)
            .overlay {
                RoundedRectangle(cornerRadius: 22, style: .continuous)
                    .stroke(Color.white.opacity(0.75), lineWidth: 1)
            }
            .shadow(color: Color.black.opacity(0.10), radius: 14, y: 8)
    }
}

private struct AppBackgroundView: View {
    var body: some View {
        ZStack {
            AppTheme.background

            Circle()
                .fill(AppTheme.accent.opacity(0.08))
                .frame(width: 300, height: 300)
                .blur(radius: 80)
                .offset(x: -220, y: -200)

            Circle()
                .fill(Color.white.opacity(0.95))
                .frame(width: 480, height: 480)
                .blur(radius: 120)
                .offset(x: 220, y: -180)
        }
        .ignoresSafeArea()
    }
}

private struct AppSidebarMaterial: NSViewRepresentable {
    func makeNSView(context: Context) -> NSVisualEffectView {
        let view = NSVisualEffectView()
        view.material = .sidebar
        view.blendingMode = .behindWindow
        view.state = .active
        return view
    }

    func updateNSView(_ nsView: NSVisualEffectView, context: Context) {}
}
