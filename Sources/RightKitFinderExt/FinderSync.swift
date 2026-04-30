#if canImport(FinderSync)
import AppKit
import Darwin
import FinderSync
import Foundation

final class FinderSync: FIFinderSync {
    private let store = AppConfigurationStore()
    private let fileActions = FileActionService()
    private let logger = RightKitLogger.finderExtension

    override init() {
        super.init()
        FIFinderSyncController.default().directoryURLs = Set(monitoredDirectoryURLs())
    }

    override func menu(for menuKind: FIMenuKind) -> NSMenu {
        let strings = RightKitStrings(language: store.loadLanguage())
        let menu = NSMenu(title: "RightKit")

        addNewFileMenu(strings: strings, to: menu)
        menu.addItem(menuItem(strings.copyPath, action: #selector(copyPath), icon: "link.circle"))
        menu.addItem(NSMenuItem.separator())
        addDestinationMenu(title: strings.copyTo, action: #selector(copyToFavorite(_:)), strings: strings, to: menu)
        addDestinationMenu(title: strings.moveTo, action: #selector(moveToFavorite(_:)), strings: strings, to: menu)
        addFavoriteDirectoryMenu(strings: strings, to: menu)
        menu.addItem(NSMenuItem.separator())
        menu.addItem(menuItem(strings.cut, action: #selector(cutSelection)))
        menu.addItem(menuItem(strings.paste, action: #selector(pasteCutItems)))

        return menu
    }

    @objc private func newFile(_ sender: NSMenuItem) {
        guard let directory = currentTargetDirectory(),
              let template = template(for: sender.tag) else {
            logger.error("Failed to resolve new file action. targetDirectory=\(self.currentTargetDirectory()?.path ?? "nil", privacy: .public) tag=\(sender.tag)")
            return
        }

        let strings = RightKitStrings(language: store.loadLanguage())
        do {
            _ = try fileActions.createFile(
                named: strings.untitledFilename(for: template),
                from: template,
                in: directory
            )
        } catch {
            logger.error("Failed to create file in \(directory.path, privacy: .public): \(error.localizedDescription, privacy: .public)")
        }
    }

    @objc private func copyToFavorite(_ sender: NSMenuItem) {
        guard let directory = favoriteDirectoryURL(for: sender.tag) else {
            logger.error("Failed to resolve copy destination for tag \(sender.tag)")
            return
        }

        do {
            _ = try fileActions.copyItems(at: selectedURLs(), to: directory)
        } catch {
            logger.error("Failed to copy items to \(directory.path, privacy: .public): \(error.localizedDescription, privacy: .public)")
        }
    }

    @objc private func moveToFavorite(_ sender: NSMenuItem) {
        guard let directory = favoriteDirectoryURL(for: sender.tag) else {
            logger.error("Failed to resolve move destination for tag \(sender.tag)")
            return
        }

        do {
            _ = try fileActions.moveItems(at: selectedURLs(), to: directory)
        } catch {
            logger.error("Failed to move items to \(directory.path, privacy: .public): \(error.localizedDescription, privacy: .public)")
        }
    }

    @objc private func copyPath() {
        do {
            try fileActions.writePathsToPasteboard(selectedURLs())
        } catch {
            logger.error("Failed to copy paths to pasteboard: \(error.localizedDescription, privacy: .public)")
        }
    }

    @objc private func cutSelection() {
        let state = CutPasteState(sourcePaths: selectedURLs().map(\.path))
        store.saveCutPasteState(state)
    }

    @objc private func pasteCutItems() {
        guard let directory = currentTargetDirectory(),
              let urls = try? fileActions.urls(from: store.loadCutPasteState()) else {
            logger.error("Failed to resolve paste action. targetDirectory=\(self.currentTargetDirectory()?.path ?? "nil", privacy: .public)")
            return
        }

        do {
            _ = try fileActions.moveItems(at: urls, to: directory)
            store.saveCutPasteState(nil)
        } catch {
            logger.error("Failed to paste cut items into \(directory.path, privacy: .public): \(error.localizedDescription, privacy: .public)")
        }
    }

    @objc private func openFavoriteDirectory(_ sender: NSMenuItem) {
        guard let directory = favoriteDirectoryURL(for: sender.tag) else {
            logger.error("Failed to resolve favorite directory for tag \(sender.tag)")
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
        let item = menuItem(strings.newFile, action: nil, icon: "doc.badge.plus")
        let submenu = NSMenu(title: strings.newFile)
        let templates = store.loadFileTemplates()
        let enabledExtensions = store.loadEnabledTemplateExtensions(availableTemplates: templates)

        for (index, template) in templates.enumerated() {
            guard enabledExtensions.contains(template.fileExtension) else {
                continue
            }

            let child = menuItem(
                strings.templateTitle(for: template),
                action: #selector(newFile(_:)),
                icon: RightKitIconProvider.templateIcon(for: template)
            )
            child.tag = index
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
        let symbolName = title == strings.copyTo ? "tray.and.arrow.down.fill" : "folder.fill.badge.minus"
        let item = menuItem(title, action: nil, icon: symbolName)
        let submenu = NSMenu(title: title)

        for (index, directory) in store.loadFavoriteDirectories().enumerated() {
            let child = menuItem(
                directory.name,
                action: action,
                icon: RightKitIconProvider.directoryIcon(for: directory.url)
            )
            child.tag = index
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
        let item = menuItem(strings.favoriteDirectoriesTitle, action: nil, icon: "heart.circle")
        let submenu = NSMenu(title: strings.favoriteDirectoriesTitle)

        for (index, directory) in store.loadFavoriteDirectories().enumerated() {
            let child = menuItem(
                directory.name,
                action: #selector(openFavoriteDirectory(_:)),
                icon: RightKitIconProvider.directoryIcon(for: directory.url)
            )
            child.tag = index
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

    private func menuItem(_ title: String, action: Selector?, icon: String? = nil) -> NSMenuItem {
        let item = NSMenuItem(title: title, action: action, keyEquivalent: "")
        item.target = self
        if store.loadShowMenuIcons(), let icon {
            item.image = RightKitIconProvider.symbol(icon)
        }
        return item
    }

    private func menuItem(_ title: String, action: Selector?, icon: NSImage?) -> NSMenuItem {
        let item = NSMenuItem(title: title, action: action, keyEquivalent: "")
        item.target = self
        if store.loadShowMenuIcons() {
            item.image = icon
        }
        return item
    }

    private func template(for tag: Int) -> NewFileTemplate? {
        let templates = store.loadFileTemplates()
        guard templates.indices.contains(tag) else {
            return nil
        }
        return templates[tag]
    }

    private func favoriteDirectoryURL(for tag: Int) -> URL? {
        let directories = store.loadFavoriteDirectories()
        guard directories.indices.contains(tag) else {
            return nil
        }
        return directories[tag].resolvedURL
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
