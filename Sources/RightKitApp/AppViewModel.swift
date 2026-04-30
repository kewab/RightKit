import AppKit
import Foundation

@MainActor
final class AppViewModel: ObservableObject {
    @Published private(set) var favoriteDirectories: [FavoriteDirectory]
    @Published private(set) var fileTemplates: [NewFileTemplate]
    @Published private(set) var enabledTemplateExtensions: Set<String>
    @Published private(set) var cutPasteState: CutPasteState?
    @Published private(set) var language: AppLanguage
    @Published private(set) var showMenuIcons: Bool
    @Published private(set) var favoriteDirectoriesEnabled: Bool
    @Published private(set) var openNewFileAfterCreate: Bool
    @Published private(set) var playSoundAfterCreate: Bool
    @Published var statusMessage: String

    private let store: AppConfigurationStore

    init(store: AppConfigurationStore = AppConfigurationStore()) {
        let loadedFavoriteDirectories = store.loadFavoriteDirectories()
        let loadedFileTemplates = store.loadFileTemplates()
        let loadedEnabledTemplateExtensions = store.loadEnabledTemplateExtensions(availableTemplates: loadedFileTemplates)
        let loadedCutPasteState = store.loadCutPasteState()
        let loadedLanguage = store.loadLanguage()
        let loadedShowMenuIcons = store.loadShowMenuIcons()
        let loadedFavoriteDirectoriesEnabled = store.loadFavoriteDirectoriesEnabled()
        let loadedOpenNewFileAfterCreate = store.loadOpenNewFileAfterCreate()
        let loadedPlaySoundAfterCreate = store.loadPlaySoundAfterCreate()

        self.store = store
        favoriteDirectories = loadedFavoriteDirectories
        fileTemplates = loadedFileTemplates
        enabledTemplateExtensions = loadedEnabledTemplateExtensions
        cutPasteState = loadedCutPasteState
        language = loadedLanguage
        showMenuIcons = loadedShowMenuIcons
        favoriteDirectoriesEnabled = loadedFavoriteDirectoriesEnabled
        openNewFileAfterCreate = loadedOpenNewFileAfterCreate
        playSoundAfterCreate = loadedPlaySoundAfterCreate
        statusMessage = RightKitStrings(language: loadedLanguage).ready
    }

    var strings: RightKitStrings {
        RightKitStrings(language: language)
    }

    func addFavoriteDirectory(_ url: URL) {
        let resolvedURL = url.standardizedFileURL
        let bookmarkData = try? resolvedURL.bookmarkData(
            options: [.withSecurityScope],
            includingResourceValuesForKeys: nil,
            relativeTo: nil
        )
        let directory = FavoriteDirectory(
            name: resolvedURL.lastPathComponent,
            path: resolvedURL.path,
            bookmarkData: bookmarkData
        )

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

    func removeFavoriteDirectory(id: FavoriteDirectory.ID?) {
        guard let id else {
            return
        }

        favoriteDirectories.removeAll { $0.id == id }
        store.saveFavoriteDirectories(favoriteDirectories)
        statusMessage = strings.removedFavoriteDirectory
    }

    func resetTemplates() {
        fileTemplates = NewFileTemplate.defaults
        store.saveFileTemplates(fileTemplates)
        enabledTemplateExtensions = Set(fileTemplates.map(\.fileExtension))
        store.saveEnabledTemplateExtensions(enabledTemplateExtensions)
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
        enabledTemplateExtensions = store.loadEnabledTemplateExtensions(availableTemplates: fileTemplates)
        cutPasteState = store.loadCutPasteState()
        language = store.loadLanguage()
        showMenuIcons = store.loadShowMenuIcons()
        favoriteDirectoriesEnabled = store.loadFavoriteDirectoriesEnabled()
        openNewFileAfterCreate = store.loadOpenNewFileAfterCreate()
        playSoundAfterCreate = store.loadPlaySoundAfterCreate()
        statusMessage = strings.reloadedSharedConfiguration
    }

    func setLanguage(_ newLanguage: AppLanguage) {
        language = newLanguage
        store.saveLanguage(newLanguage)
        statusMessage = strings.languageChanged(to: newLanguage)
    }

    func setShowMenuIcons(_ isEnabled: Bool) {
        showMenuIcons = isEnabled
        store.saveShowMenuIcons(isEnabled)
        statusMessage = strings.reloadedSharedConfiguration
    }

    func setFavoriteDirectoriesEnabled(_ isEnabled: Bool) {
        favoriteDirectoriesEnabled = isEnabled
        store.saveFavoriteDirectoriesEnabled(isEnabled)
        statusMessage = strings.reloadedSharedConfiguration
    }

    func setOpenNewFileAfterCreate(_ isEnabled: Bool) {
        openNewFileAfterCreate = isEnabled
        store.saveOpenNewFileAfterCreate(isEnabled)
        statusMessage = strings.reloadedSharedConfiguration
    }

    func setPlaySoundAfterCreate(_ isEnabled: Bool) {
        playSoundAfterCreate = isEnabled
        store.savePlaySoundAfterCreate(isEnabled)
        statusMessage = strings.reloadedSharedConfiguration
    }

    func isTemplateEnabled(_ template: NewFileTemplate) -> Bool {
        enabledTemplateExtensions.contains(template.fileExtension)
    }

    func setTemplateEnabled(_ isEnabled: Bool, for template: NewFileTemplate) {
        if isEnabled {
            enabledTemplateExtensions.insert(template.fileExtension)
        } else {
            enabledTemplateExtensions.remove(template.fileExtension)
        }

        store.saveEnabledTemplateExtensions(enabledTemplateExtensions)
        statusMessage = strings.reloadedSharedConfiguration
    }

    func copyFinderActivationCommand() {
        let command = [
            "pluginkit -e use -i \(RightKitBundle.finderExtensionIdentifier)",
            "killall Finder"
        ].joined(separator: "\n")
        NSPasteboard.general.clearContents()
        NSPasteboard.general.setString(command, forType: .string)
        statusMessage = strings.finderActivationCommandCopied
    }
}
