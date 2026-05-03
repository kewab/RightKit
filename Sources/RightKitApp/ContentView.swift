import SwiftUI

struct ContentView: View {
    @ObservedObject var viewModel: AppViewModel
    @State private var selection: SidebarSection? = .general
    @State private var searchText = ""

    var body: some View {
        NavigationSplitView {
            AppSidebar(
                selection: $selection,
                searchText: $searchText,
                strings: viewModel.strings,
                sections: filteredSections
            )
            .frame(minWidth: 280, idealWidth: 300, maxWidth: 340)
        } detail: {
            detailView
                .padding(.horizontal, 20)
                .padding(.vertical, 16)
                .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .topLeading)
        }
        .navigationSplitViewStyle(.balanced)
        .background(AppWindowBackground())
        .frame(minWidth: 1180, minHeight: 780)
        .preferredColorScheme(.dark)
    }

    @ViewBuilder
    private var detailView: some View {
        switch selection ?? .general {
        case .general:
            GeneralSettingsView(viewModel: viewModel)
        case .newFile:
            FileTemplatesView(viewModel: viewModel)
        case .favorites:
            FavoriteDirectoriesView(viewModel: viewModel)
        }
    }

    private var filteredSections: [SidebarSection] {
        let query = searchText.trimmingCharacters(in: .whitespacesAndNewlines)
        guard !query.isEmpty else {
            return SidebarSection.allCases
        }
        return SidebarSection.allCases.filter { section in
            section.matches(query: query, strings: viewModel.strings)
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

    var iconStyle: SidebarIconStyle {
        switch self {
        case .general:
            .general
        case .newFile:
            .newFile
        case .favorites:
            .favorites
        }
    }

    func matches(query: String, strings: RightKitStrings) -> Bool {
        let normalizedQuery = query.lowercased()
        return title(strings: strings).lowercased().contains(normalizedQuery) ||
            subtitle(strings: strings).lowercased().contains(normalizedQuery)
    }
}

private struct AppSidebar: View {
    @Binding var selection: SidebarSection?
    @Binding var searchText: String
    let strings: RightKitStrings
    let sections: [SidebarSection]

    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            SidebarHeader()
                .padding(.top, 8)

            SidebarSearchField(
                text: $searchText,
                placeholder: strings.language == .chinese ? "搜索" : "Search"
            )

            List(selection: $selection) {
                ForEach(sections) { section in
                    SidebarRow(
                        title: section.title(strings: strings),
                        iconStyle: section.iconStyle
                    )
                    .tag(Optional(section))
                    .listRowInsets(EdgeInsets(top: 4, leading: 8, bottom: 4, trailing: 8))
                    .listRowSeparator(.hidden)
                    .listRowBackground(Color.clear)
                }
            }
            .listStyle(.sidebar)
            .scrollContentBackground(.hidden)
        }
        .padding(.horizontal, 10)
        .padding(.bottom, 10)
        .background(
            RoundedRectangle(cornerRadius: 20, style: .continuous)
                .fill(AppTheme.sidebarPanelFill)
                .overlay {
                    RoundedRectangle(cornerRadius: 20, style: .continuous)
                        .stroke(AppTheme.sidebarPanelBorder, lineWidth: 1)
                }
        )
        .padding(.horizontal, 12)
        .padding(.vertical, 10)
    }
}

private struct SidebarHeader: View {
    var body: some View {
        HStack(spacing: 12) {
            RoundedRectangle(cornerRadius: 11, style: .continuous)
                .fill(
                    LinearGradient(
                        colors: [Color(red: 0.27, green: 0.62, blue: 1.0), Color(red: 0.08, green: 0.41, blue: 0.95)],
                        startPoint: .topLeading,
                        endPoint: .bottomTrailing
                    )
                )
                .overlay {
                    Image(systemName: "folder.badge.gearshape")
                        .font(.system(size: 18, weight: .semibold))
                        .foregroundStyle(.white)
                }
                .frame(width: 42, height: 42)

            VStack(alignment: .leading, spacing: 2) {
                Text("RightKit")
                    .font(.system(size: 19, weight: .semibold))
                    .foregroundStyle(AppTheme.primaryText)
                Text("Finder Extension")
                    .font(.system(size: 12, weight: .medium))
                    .foregroundStyle(AppTheme.secondaryText)
            }

            Spacer()
        }
        .padding(.horizontal, 10)
    }
}

private struct SidebarSearchField: View {
    @Binding var text: String
    let placeholder: String

    var body: some View {
        HStack(spacing: 8) {
            Image(systemName: "magnifyingglass")
                .foregroundStyle(AppTheme.tertiaryText)
                .font(.system(size: 13, weight: .semibold))

            TextField(placeholder, text: $text)
                .textFieldStyle(.plain)
                .font(.system(size: 15, weight: .medium))
                .foregroundStyle(AppTheme.primaryText)
        }
        .padding(.horizontal, 12)
        .frame(height: 38)
        .background(
            RoundedRectangle(cornerRadius: 11, style: .continuous)
                .fill(AppTheme.searchFieldFill)
                .overlay {
                    RoundedRectangle(cornerRadius: 11, style: .continuous)
                        .stroke(AppTheme.searchFieldBorder, lineWidth: 1)
                }
        )
        .padding(.horizontal, 8)
    }
}

private struct SidebarRow: View {
    let title: String
    let iconStyle: SidebarIconStyle

    var body: some View {
        HStack(spacing: 10) {
            SidebarIcon(style: iconStyle)
            Text(title)
                .font(.system(size: 16, weight: .semibold))
                .foregroundStyle(AppTheme.primaryText)
            Spacer()
        }
        .padding(.horizontal, 10)
        .frame(height: 46)
        .contentShape(RoundedRectangle(cornerRadius: 11, style: .continuous))
    }
}
