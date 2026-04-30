import SwiftUI

struct ContentView: View {
    @StateObject private var viewModel = AppViewModel()

    var body: some View {
        TabView {
            FavoriteDirectoriesView(viewModel: viewModel)
                .tabItem {
                    Label(viewModel.strings.favoritesTab, systemImage: "folder")
                }

            FileTemplatesView(viewModel: viewModel)
                .tabItem {
                    Label(viewModel.strings.templatesTab, systemImage: "doc")
                }

            StatusView(viewModel: viewModel)
                .tabItem {
                    Label(viewModel.strings.statusTab, systemImage: "gearshape")
                }
        }
        .frame(minWidth: 760, minHeight: 520)
    }
}
