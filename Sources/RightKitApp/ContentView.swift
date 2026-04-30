import SwiftUI

struct ContentView: View {
    @StateObject private var viewModel = AppViewModel()
    @State private var selection: SidebarSection = .general

    var body: some View {
        HStack(spacing: 0) {
            AppSidebar(selection: $selection, strings: viewModel.strings)
            Divider().overlay(Color.white.opacity(0.04))
            contentView
                .frame(maxWidth: .infinity, maxHeight: .infinity)
        }
        .background(AppBackgroundView())
        .frame(minWidth: 1100, minHeight: 760)
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
}

private struct AppSidebar: View {
    @Binding var selection: SidebarSection
    let strings: RightKitStrings

    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            VStack(spacing: 14) {
                AppBrandBadge()
                Text("RightKit 0.1.0")
                    .font(.system(size: 16, weight: .semibold))
                    .foregroundStyle(.white.opacity(0.92))
            }
            .frame(maxWidth: .infinity)
            .padding(.top, 54)
            .padding(.bottom, 42)

            VStack(spacing: 14) {
                ForEach(sidebarItems(strings: strings)) { item in
                    SidebarButton(
                        item: item,
                        isSelected: item.section == selection
                    ) {
                        selection = item.section
                    }
                }
            }
            .padding(.horizontal, 20)

            Spacer()
        }
        .frame(width: 280)
        .background(
            LinearGradient(
                colors: [
                    Color(red: 0.13, green: 0.15, blue: 0.17),
                    Color(red: 0.21, green: 0.21, blue: 0.22)
                ],
                startPoint: .top,
                endPoint: .bottom
            )
        )
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

    var body: some View {
        Button(action: action) {
            HStack(spacing: 16) {
                ZStack {
                    RoundedRectangle(cornerRadius: 11, style: .continuous)
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
                        .font(.system(size: 20, weight: .semibold))
                        .foregroundStyle(.white)
                }
                .frame(width: 44, height: 44)

                Text(item.title)
                    .font(.system(size: 18, weight: .semibold))
                    .foregroundStyle(.white.opacity(0.95))

                Spacer()
            }
            .padding(.horizontal, 18)
            .frame(height: 66)
            .background(
                RoundedRectangle(cornerRadius: 18, style: .continuous)
                    .fill(isSelected ? Color.white.opacity(0.12) : Color.clear)
            )
        }
        .buttonStyle(.plain)
    }
}

private struct AppBrandBadge: View {
    var body: some View {
        RoundedRectangle(cornerRadius: 24, style: .continuous)
            .fill(
                LinearGradient(
                    colors: [
                        Color.white.opacity(0.96),
                        Color(red: 0.90, green: 0.96, blue: 1.0)
                    ],
                    startPoint: .topLeading,
                    endPoint: .bottomTrailing
                )
            )
            .overlay {
                Text("R")
                    .font(.system(size: 54, weight: .bold, design: .rounded))
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
            .frame(width: 110, height: 110)
            .shadow(color: .black.opacity(0.18), radius: 12, y: 8)
    }
}

private struct AppBackgroundView: View {
    var body: some View {
        ZStack {
            LinearGradient(
                colors: [
                    Color(red: 0.17, green: 0.22, blue: 0.27),
                    Color(red: 0.31, green: 0.38, blue: 0.44)
                ],
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )

            Circle()
                .fill(Color(red: 0.24, green: 0.80, blue: 0.88).opacity(0.16))
                .frame(width: 380, height: 380)
                .blur(radius: 100)
                .offset(x: 140, y: 250)

            Circle()
                .fill(Color(red: 0.98, green: 0.56, blue: 0.42).opacity(0.14))
                .frame(width: 320, height: 320)
                .blur(radius: 95)
                .offset(x: -60, y: 290)
        }
        .ignoresSafeArea()
    }
}
