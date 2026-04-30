#if canImport(FinderSync)
import AppKit
import FinderSync
import Foundation

final class FinderSync: FIFinderSync {
    private let store = AppConfigurationStore()
    private let fileActions = FileActionService()

    override init() {
        super.init()
        FIFinderSyncController.default().directoryURLs = [URL(fileURLWithPath: NSHomeDirectory())]
    }

    override func menu(for menuKind: FIMenuKind) -> NSMenu {
        let menu = NSMenu(title: "RightKit")

        menu.addItem(menuItem("New Text File", action: #selector(newTextFile)))
        menu.addItem(NSMenuItem.separator())

        addDestinationMenu(title: "Copy To", action: #selector(copyToFavorite(_:)), to: menu)
        addDestinationMenu(title: "Move To", action: #selector(moveToFavorite(_:)), to: menu)

        menu.addItem(NSMenuItem.separator())
        menu.addItem(menuItem("Copy Path", action: #selector(copyPath)))
        menu.addItem(menuItem("Cut", action: #selector(cutSelection)))
        menu.addItem(menuItem("Paste", action: #selector(pasteCutItems)))

        return menu
    }

    @objc private func newTextFile() {
        guard let directory = currentTargetDirectory(),
              let template = store.loadFileTemplates().first(where: { $0.fileExtension == "txt" }) else {
            return
        }

        _ = try? fileActions.createFile(named: template.suggestedFilename, from: template, in: directory)
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

    private func addDestinationMenu(title: String, action: Selector, to menu: NSMenu) {
        let item = NSMenuItem(title: title, action: nil, keyEquivalent: "")
        let submenu = NSMenu(title: title)

        for directory in store.loadFavoriteDirectories() {
            let child = menuItem(directory.name, action: action)
            child.representedObject = directory.url
            submenu.addItem(child)
        }

        if submenu.items.isEmpty {
            let emptyItem = NSMenuItem(title: "No Favorite Directories", action: nil, keyEquivalent: "")
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
}
#endif
