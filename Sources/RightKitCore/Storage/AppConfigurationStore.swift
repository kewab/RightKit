import Foundation

final class AppConfigurationStore {
    private enum Key {
        static let favoriteDirectories = "favoriteDirectories"
        static let fileTemplates = "fileTemplates"
        static let enabledTemplateExtensions = "enabledTemplateExtensions"
        static let cutPasteState = "cutPasteState"
        static let language = "language"
        static let showContextMenuIcons = "showMenuIcons"
        static let favoriteDirectoriesEnabled = "favoriteDirectoriesEnabled"
        static let openNewFileAfterCreate = "openNewFileAfterCreate"
        static let playSoundAfterCreate = "playSoundAfterCreate"
        static let finderExtensionSessionActive = "finderExtensionSessionActive"
    }

    private let defaults: UserDefaults
    private let encoder = JSONEncoder()
    private let decoder = JSONDecoder()

    init(suiteName: String? = AppGroup.identifier) {
        if let suiteName, let sharedDefaults = UserDefaults(suiteName: suiteName) {
            defaults = sharedDefaults
        } else {
            defaults = .standard
        }
    }

    func loadFavoriteDirectories() -> [FavoriteDirectory] {
        load([FavoriteDirectory].self, forKey: Key.favoriteDirectories) ?? []
    }

    func saveFavoriteDirectories(_ directories: [FavoriteDirectory]) {
        save(directories, forKey: Key.favoriteDirectories)
    }

    func loadFileTemplates() -> [NewFileTemplate] {
        load([NewFileTemplate].self, forKey: Key.fileTemplates) ?? NewFileTemplate.defaults
    }

    func saveFileTemplates(_ templates: [NewFileTemplate]) {
        save(templates, forKey: Key.fileTemplates)
    }

    func loadEnabledTemplateExtensions(availableTemplates: [NewFileTemplate]? = nil) -> Set<String> {
        let fallbackTemplates = availableTemplates ?? loadFileTemplates()
        let fallbackExtensions = Set(fallbackTemplates.map(\.fileExtension))
        guard let storedExtensions = load([String].self, forKey: Key.enabledTemplateExtensions) else {
            return fallbackExtensions
        }
        return Set(storedExtensions)
    }

    func saveEnabledTemplateExtensions(_ extensions: Set<String>) {
        save(Array(extensions).sorted(), forKey: Key.enabledTemplateExtensions)
    }

    func loadCutPasteState() -> CutPasteState? {
        load(CutPasteState.self, forKey: Key.cutPasteState)
    }

    func saveCutPasteState(_ state: CutPasteState?) {
        guard let state else {
            defaults.removeObject(forKey: Key.cutPasteState)
            return
        }
        save(state, forKey: Key.cutPasteState)
    }

    func loadLanguage() -> AppLanguage {
        guard let rawValue = defaults.string(forKey: Key.language),
              let language = AppLanguage(rawValue: rawValue) else {
            return .chinese
        }
        return language
    }

    func saveLanguage(_ language: AppLanguage) {
        defaults.set(language.rawValue, forKey: Key.language)
    }

    func loadShowContextMenuIcons() -> Bool {
        loadBool(forKey: Key.showContextMenuIcons, defaultValue: true)
    }

    func saveShowContextMenuIcons(_ isEnabled: Bool) {
        defaults.set(isEnabled, forKey: Key.showContextMenuIcons)
    }

    func loadFavoriteDirectoriesEnabled() -> Bool {
        loadBool(forKey: Key.favoriteDirectoriesEnabled, defaultValue: true)
    }

    func saveFavoriteDirectoriesEnabled(_ isEnabled: Bool) {
        defaults.set(isEnabled, forKey: Key.favoriteDirectoriesEnabled)
    }

    func loadOpenNewFileAfterCreate() -> Bool {
        loadBool(forKey: Key.openNewFileAfterCreate, defaultValue: false)
    }

    func saveOpenNewFileAfterCreate(_ isEnabled: Bool) {
        defaults.set(isEnabled, forKey: Key.openNewFileAfterCreate)
    }

    func loadPlaySoundAfterCreate() -> Bool {
        loadBool(forKey: Key.playSoundAfterCreate, defaultValue: false)
    }

    func savePlaySoundAfterCreate(_ isEnabled: Bool) {
        defaults.set(isEnabled, forKey: Key.playSoundAfterCreate)
    }

    func loadFinderExtensionSessionActive() -> Bool {
        loadBool(forKey: Key.finderExtensionSessionActive, defaultValue: false)
    }

    func saveFinderExtensionSessionActive(_ isActive: Bool) {
        defaults.set(isActive, forKey: Key.finderExtensionSessionActive)
    }

    private func load<T: Decodable>(_ type: T.Type, forKey key: String) -> T? {
        guard let data = defaults.data(forKey: key) else {
            return nil
        }
        return try? decoder.decode(type, from: data)
    }

    private func save<T: Encodable>(_ value: T, forKey key: String) {
        guard let data = try? encoder.encode(value) else {
            return
        }
        defaults.set(data, forKey: key)
    }

    private func loadBool(forKey key: String, defaultValue: Bool) -> Bool {
        guard defaults.object(forKey: key) != nil else {
            return defaultValue
        }
        return defaults.bool(forKey: key)
    }
}
