import Foundation

final class AppConfigurationStore {
    private enum Key {
        static let favoriteDirectories = "favoriteDirectories"
        static let fileTemplates = "fileTemplates"
        static let cutPasteState = "cutPasteState"
        static let language = "language"
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
}
