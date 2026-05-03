import AppKit
import Foundation

@MainActor
final class AppLifecycleCoordinator: ObservableObject {
    static let shared = AppLifecycleCoordinator()

    @Published private(set) var isMenuBarOnly = false

    private let finderExtensionController: FinderExtensionController
    private var allowsTermination = false

    private init() {
        finderExtensionController = FinderExtensionController()
    }

    func applicationDidFinishLaunching() {
        finderExtensionController.setHostAppRunning(true)
        restoreDockVisibility()
    }

    func applicationShouldTerminate() -> NSApplication.TerminateReply {
        guard !allowsTermination else {
            return .terminateNow
        }

        moveToMenuBar()
        return .terminateCancel
    }

    func applicationShouldHandleReopen() {
        revealMainWindow()
    }

    func applicationWillTerminate() {
        finderExtensionController.setHostAppRunning(false)
    }

    func revealMainWindow() {
        restoreDockVisibility()
        NSApp.unhide(nil)
        NSApp.activate(ignoringOtherApps: true)
    }

    func requestTermination() {
        allowsTermination = true
        NSApp.terminate(nil)
    }

    private func moveToMenuBar() {
        isMenuBarOnly = true
        NSApp.setActivationPolicy(.accessory)
        NSApp.hide(nil)
    }

    private func restoreDockVisibility() {
        if NSApp.activationPolicy() != .regular {
            NSApp.setActivationPolicy(.regular)
        }
        isMenuBarOnly = false
    }
}
