import Foundation

@MainActor
final class FinderExtensionController {
    private let store: AppConfigurationStore

    init(store: AppConfigurationStore = AppConfigurationStore()) {
        self.store = store
    }

    func setHostAppRunning(_ isRunning: Bool) {
        store.saveFinderExtensionSessionActive(isRunning)
    }
}
