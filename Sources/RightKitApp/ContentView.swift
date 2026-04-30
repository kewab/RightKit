import SwiftUI

struct ContentView: View {
    @StateObject private var viewModel = AppViewModel()

    var body: some View {
        TabView {
            FavoriteDirectoriesView(viewModel: viewModel)
                .tabItem {
                    Label("Favorites", systemImage: "folder")
                }

            FileTemplatesView(viewModel: viewModel)
                .tabItem {
                    Label("Templates", systemImage: "doc")
                }

            StatusView(viewModel: viewModel)
                .tabItem {
                    Label("Status", systemImage: "gearshape")
                }
        }
        .frame(minWidth: 760, minHeight: 520)
    }
}
