import AppKit
import Foundation

@MainActor
final class AppViewModel: ObservableObject {
    @Published private(set) var favoriteDirectories: [FavoriteDirectory]
    @Published private(set) var fileTemplates: [NewFileTemplate]
    @Published private(set) var cutPasteState: CutPasteState?
    @Published var statusMessage: String = "Ready"

    private let store: AppConfigurationStore

    init(store: AppConfigurationStore = AppConfigurationStore()) {
        self.store = store
        favoriteDirectories = store.loadFavoriteDirectories()
        fileTemplates = store.loadFileTemplates()
        cutPasteState = store.loadCutPasteState()
    }

    func addFavoriteDirectory(_ url: URL) {
        let resolvedURL = url.standardizedFileURL
        let directory = FavoriteDirectory(name: resolvedURL.lastPathComponent, path: resolvedURL.path)

        guard !favoriteDirectories.contains(where: { $0.path == directory.path }) else {
            statusMessage = "Directory already exists: \(directory.path)"
            return
        }

        favoriteDirectories.append(directory)
        store.saveFavoriteDirectories(favoriteDirectories)
        statusMessage = "Added favorite directory: \(directory.name)"
    }

    func removeFavoriteDirectories(at offsets: IndexSet) {
        favoriteDirectories.remove(atOffsets: offsets)
        store.saveFavoriteDirectories(favoriteDirectories)
        statusMessage = "Removed favorite directory"
    }

    func resetTemplates() {
        fileTemplates = NewFileTemplate.defaults
        store.saveFileTemplates(fileTemplates)
        statusMessage = "Templates reset"
    }

    func clearCutPasteState() {
        cutPasteState = nil
        store.saveCutPasteState(nil)
        statusMessage = "Cut state cleared"
    }

    func reload() {
        favoriteDirectories = store.loadFavoriteDirectories()
        fileTemplates = store.loadFileTemplates()
        cutPasteState = store.loadCutPasteState()
        statusMessage = "Reloaded shared configuration"
    }
}
