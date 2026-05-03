import AppKit
import Foundation

@MainActor
final class RightKitAppDelegate: NSObject, NSApplicationDelegate {
    private let lifecycle = AppLifecycleCoordinator.shared

    func applicationDidFinishLaunching(_ notification: Notification) {
        lifecycle.applicationDidFinishLaunching()
    }

    func applicationShouldTerminate(_ sender: NSApplication) -> NSApplication.TerminateReply {
        lifecycle.applicationShouldTerminate()
    }

    func applicationShouldTerminateAfterLastWindowClosed(_ sender: NSApplication) -> Bool {
        false
    }

    func applicationShouldHandleReopen(_ sender: NSApplication, hasVisibleWindows flag: Bool) -> Bool {
        lifecycle.applicationShouldHandleReopen()
        return true
    }

    func applicationWillTerminate(_ notification: Notification) {
        lifecycle.applicationWillTerminate()
    }
}
