import AppKit
import Foundation

@MainActor
final class AppViewModel: ObservableObject {
    @Published private(set) var favoriteDirectories: [FavoriteDirectory]
    @Published private(set) var fileTemplates: [NewFileTemplate]
    @Published private(set) var cutPasteState: CutPasteState?
    @Published private(set) var language: AppLanguage
    @Published var statusMessage: String

    private let store: AppConfigurationStore

    init(store: AppConfigurationStore = AppConfigurationStore()) {
        self.store = store
        favoriteDirectories = store.loadFavoriteDirectories()
        fileTemplates = store.loadFileTemplates()
        cutPasteState = store.loadCutPasteState()
        let loadedLanguage = store.loadLanguage()
        language = loadedLanguage
        statusMessage = RightKitStrings(language: loadedLanguage).ready
    }

    var strings: RightKitStrings {
        RightKitStrings(language: language)
    }

    func addFavoriteDirectory(_ url: URL) {
        let resolvedURL = url.standardizedFileURL
        let directory = FavoriteDirectory(name: resolvedURL.lastPathComponent, path: resolvedURL.path)

        guard !favoriteDirectories.contains(where: { $0.path == directory.path }) else {
            statusMessage = strings.directoryAlreadyExists(directory.path)
            return
        }

        favoriteDirectories.append(directory)
        store.saveFavoriteDirectories(favoriteDirectories)
        statusMessage = strings.addedFavoriteDirectory(directory.name)
    }

    func removeFavoriteDirectories(at offsets: IndexSet) {
        favoriteDirectories.remove(atOffsets: offsets)
        store.saveFavoriteDirectories(favoriteDirectories)
        statusMessage = strings.removedFavoriteDirectory
    }

    func resetTemplates() {
        fileTemplates = NewFileTemplate.defaults
        store.saveFileTemplates(fileTemplates)
        statusMessage = strings.templatesReset
    }

    func clearCutPasteState() {
        cutPasteState = nil
        store.saveCutPasteState(nil)
        statusMessage = strings.cutStateCleared
    }

    func reload() {
        favoriteDirectories = store.loadFavoriteDirectories()
        fileTemplates = store.loadFileTemplates()
        cutPasteState = store.loadCutPasteState()
        language = store.loadLanguage()
        statusMessage = strings.reloadedSharedConfiguration
    }

    func setLanguage(_ newLanguage: AppLanguage) {
        language = newLanguage
        store.saveLanguage(newLanguage)
        statusMessage = strings.languageChanged(to: newLanguage)
    }
}
