import AppKit
import Foundation

@MainActor
final class AppViewModel: ObservableObject {
    @Published private(set) var favoriteDirectories: [FavoriteDirectory]
    @Published private(set) var fileTemplates: [NewFileTemplate]
    @Published private(set) var enabledTemplateExtensions: Set<String>
    @Published private(set) var cutPasteState: CutPasteState?
    @Published private(set) var language: AppLanguage
    @Published private(set) var showContextMenuIcons: Bool
    @Published private(set) var favoriteDirectoriesEnabled: Bool
    @Published private(set) var openNewFileAfterCreate: Bool
    @Published private(set) var playSoundAfterCreate: Bool
    @Published private(set) var launchAtLoginEnabled: Bool
    @Published var statusMessage: String

    private let store: AppConfigurationStore
    private let launchAtLoginController: LaunchAtLoginController

    init(store: AppConfigurationStore = AppConfigurationStore()) {
        let launchAtLoginController = LaunchAtLoginController()
        let loadedFavoriteDirectories = store.loadFavoriteDirectories()
        let loadedFileTemplates = store.loadFileTemplates()
        let loadedEnabledTemplateExtensions = store.loadEnabledTemplateExtensions(availableTemplates: loadedFileTemplates)
        let loadedCutPasteState = store.loadCutPasteState()
        let loadedLanguage = store.loadLanguage()
        let loadedShowContextMenuIcons = store.loadShowContextMenuIcons()
        let loadedFavoriteDirectoriesEnabled = store.loadFavoriteDirectoriesEnabled()
        let loadedOpenNewFileAfterCreate = store.loadOpenNewFileAfterCreate()
        let loadedPlaySoundAfterCreate = store.loadPlaySoundAfterCreate()
        let loadedLaunchAtLoginEnabled = launchAtLoginController.currentState().isToggleOn

        self.store = store
        self.launchAtLoginController = launchAtLoginController
        favoriteDirectories = loadedFavoriteDirectories
        fileTemplates = loadedFileTemplates
        enabledTemplateExtensions = loadedEnabledTemplateExtensions
        cutPasteState = loadedCutPasteState
        language = loadedLanguage
        showContextMenuIcons = loadedShowContextMenuIcons
        favoriteDirectoriesEnabled = loadedFavoriteDirectoriesEnabled
        openNewFileAfterCreate = loadedOpenNewFileAfterCreate
        playSoundAfterCreate = loadedPlaySoundAfterCreate
        launchAtLoginEnabled = loadedLaunchAtLoginEnabled
        statusMessage = RightKitStrings(language: loadedLanguage).ready
    }

    var strings: RightKitStrings {
        RightKitStrings(language: language)
    }

    func addFavoriteDirectory(_ url: URL) {
        let resolvedURL = url.standardizedFileURL
        let bookmarkData = SecurityScopedBookmark.make(for: resolvedURL)
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
        showContextMenuIcons = store.loadShowContextMenuIcons()
        favoriteDirectoriesEnabled = store.loadFavoriteDirectoriesEnabled()
        openNewFileAfterCreate = store.loadOpenNewFileAfterCreate()
        playSoundAfterCreate = store.loadPlaySoundAfterCreate()
        launchAtLoginEnabled = launchAtLoginController.currentState().isToggleOn
        statusMessage = strings.reloadedSharedConfiguration
    }

    func setLanguage(_ newLanguage: AppLanguage) {
        language = newLanguage
        store.saveLanguage(newLanguage)
        statusMessage = strings.languageChanged(to: newLanguage)
    }

    func setShowContextMenuIcons(_ isEnabled: Bool) {
        showContextMenuIcons = isEnabled
        store.saveShowContextMenuIcons(isEnabled)
        statusMessage = strings.reloadedSharedConfiguration
    }

    func setLaunchAtLogin(_ isEnabled: Bool) {
        do {
            let state = try launchAtLoginController.setEnabled(isEnabled)
            launchAtLoginEnabled = state.isToggleOn

            switch state {
            case .enabled:
                statusMessage = strings.launchAtLoginEnabledStatus
            case .notRegistered:
                statusMessage = strings.launchAtLoginDisabledStatus
            case .requiresApproval:
                statusMessage = strings.launchAtLoginRequiresApprovalStatus
            case .notFound:
                statusMessage = strings.launchAtLoginUnavailableStatus
            }
        } catch {
            launchAtLoginEnabled = launchAtLoginController.currentState().isToggleOn
            statusMessage = strings.launchAtLoginChangeFailed(error.localizedDescription)
        }
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

    func openFinderExtensionSettings() {
        guard let url = URL(string: "x-apple.systempreferences:com.apple.ExtensionsPreferences") else {
            return
        }

        NSWorkspace.shared.open(url)
        statusMessage = strings.finderExtensionSettingsOpened
    }
}
