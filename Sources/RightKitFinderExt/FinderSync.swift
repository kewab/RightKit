#if canImport(FinderSync)
import AppKit
import Darwin
import FinderSync
import Foundation

final class FinderSync: FIFinderSync {
    private let store = AppConfigurationStore()
    private let fileActions = FileActionService()

    override init() {
        super.init()
        FIFinderSyncController.default().directoryURLs = Set(monitoredDirectoryURLs())
    }

    override func menu(for menuKind: FIMenuKind) -> NSMenu {
        let strings = RightKitStrings(language: store.loadLanguage())
        let menu = NSMenu(title: "RightKit")

        addNewFileMenu(strings: strings, to: menu)
        menu.addItem(NSMenuItem.separator())

        addDestinationMenu(title: strings.copyTo, action: #selector(copyToFavorite(_:)), strings: strings, to: menu)
        addDestinationMenu(title: strings.moveTo, action: #selector(moveToFavorite(_:)), strings: strings, to: menu)
        addFavoriteDirectoryMenu(strings: strings, to: menu)

        menu.addItem(NSMenuItem.separator())
        menu.addItem(menuItem(strings.copyPath, action: #selector(copyPath)))
        menu.addItem(menuItem(strings.cut, action: #selector(cutSelection)))
        menu.addItem(menuItem(strings.paste, action: #selector(pasteCutItems)))

        return menu
    }

    @objc private func newFile(_ sender: NSMenuItem) {
        guard let directory = currentTargetDirectory(),
              let template = sender.representedObject as? NewFileTemplate else {
            return
        }

        let strings = RightKitStrings(language: store.loadLanguage())
        _ = try? fileActions.createFile(
            named: strings.untitledFilename(for: template),
            from: template,
            in: directory
        )
    }

    @objc private func copyToFavorite(_ sender: NSMenuItem) {
        guard let directory = sender.representedObject as? URL else {
            return
        }
        _ = try? fileActions.copyItems(at: selectedURLs(), to: directory)
    }

    @objc private func moveToFavorite(_ sender: NSMenuItem) {
        guard let directory = sender.representedObject as? URL else {
            return
        }
        _ = try? fileActions.moveItems(at: selectedURLs(), to: directory)
    }

    @objc private func copyPath() {
        try? fileActions.writePathsToPasteboard(selectedURLs())
    }

    @objc private func cutSelection() {
        let state = CutPasteState(sourcePaths: selectedURLs().map(\.path))
        store.saveCutPasteState(state)
    }

    @objc private func pasteCutItems() {
        guard let directory = currentTargetDirectory(),
              let urls = try? fileActions.urls(from: store.loadCutPasteState()) else {
            return
        }

        if (try? fileActions.moveItems(at: urls, to: directory)) != nil {
            store.saveCutPasteState(nil)
        }
    }

    @objc private func openFavoriteDirectory(_ sender: NSMenuItem) {
        guard let directory = sender.representedObject as? URL else {
            return
        }
        NSWorkspace.shared.open(directory)
    }

    private func selectedURLs() -> [URL] {
        FIFinderSyncController.default().selectedItemURLs() ?? []
    }

    private func currentTargetDirectory() -> URL? {
        let controller = FIFinderSyncController.default()

        if let targetedURL = controller.targetedURL() {
            return targetedURL
        }

        if let firstSelection = selectedURLs().first {
            var isDirectory: ObjCBool = false
            if FileManager.default.fileExists(atPath: firstSelection.path, isDirectory: &isDirectory),
               isDirectory.boolValue {
                return firstSelection
            }
            return firstSelection.deletingLastPathComponent()
        }

        return nil
    }

    private func addNewFileMenu(strings: RightKitStrings, to menu: NSMenu) {
        let item = NSMenuItem(title: strings.newFile, action: nil, keyEquivalent: "")
        let submenu = NSMenu(title: strings.newFile)
        let templates = store.loadFileTemplates()

        for template in templates {
            let child = menuItem(strings.templateTitle(for: template), action: #selector(newFile(_:)))
            child.representedObject = template
            submenu.addItem(child)
        }

        if submenu.items.isEmpty {
            let emptyItem = NSMenuItem(title: strings.noTemplates, action: nil, keyEquivalent: "")
            emptyItem.isEnabled = false
            submenu.addItem(emptyItem)
        }

        item.submenu = submenu
        menu.addItem(item)
    }

    private func addDestinationMenu(title: String, action: Selector, strings: RightKitStrings, to menu: NSMenu) {
        let item = NSMenuItem(title: title, action: nil, keyEquivalent: "")
        let submenu = NSMenu(title: title)

        for directory in store.loadFavoriteDirectories() {
            let child = menuItem(directory.name, action: action)
            child.representedObject = directory.url
            submenu.addItem(child)
        }

        if submenu.items.isEmpty {
            let emptyItem = NSMenuItem(title: strings.noFavoriteDirectories, action: nil, keyEquivalent: "")
            emptyItem.isEnabled = false
            submenu.addItem(emptyItem)
        }

        item.submenu = submenu
        menu.addItem(item)
    }

    private func addFavoriteDirectoryMenu(strings: RightKitStrings, to menu: NSMenu) {
        let item = NSMenuItem(title: strings.favoriteDirectoriesTitle, action: nil, keyEquivalent: "")
        let submenu = NSMenu(title: strings.favoriteDirectoriesTitle)

        for directory in store.loadFavoriteDirectories() {
            let child = menuItem(directory.name, action: #selector(openFavoriteDirectory(_:)))
            child.representedObject = directory.url
            submenu.addItem(child)
        }

        if submenu.items.isEmpty {
            let emptyItem = NSMenuItem(title: strings.noFavoriteDirectories, action: nil, keyEquivalent: "")
            emptyItem.isEnabled = false
            submenu.addItem(emptyItem)
        }

        item.submenu = submenu
        menu.addItem(item)
    }

    private func menuItem(_ title: String, action: Selector) -> NSMenuItem {
        let item = NSMenuItem(title: title, action: action, keyEquivalent: "")
        item.target = self
        return item
    }

    private func monitoredDirectoryURLs() -> [URL] {
        guard let passwordEntry = getpwuid(getuid()) else {
            return []
        }

        let homePath = String(cString: passwordEntry.pointee.pw_dir)
        let homeURL = URL(fileURLWithPath: homePath, isDirectory: true)
        return [homeURL]
    }
}
#endif
