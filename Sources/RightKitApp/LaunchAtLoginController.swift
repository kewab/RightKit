import Foundation
import ServiceManagement

@MainActor
final class LaunchAtLoginController {
    enum State {
        case notRegistered
        case enabled
        case requiresApproval
        case notFound

        var isToggleOn: Bool {
            switch self {
            case .enabled, .requiresApproval:
                return true
            case .notRegistered, .notFound:
                return false
            }
        }
    }

    func currentState() -> State {
        switch SMAppService.mainApp.status {
        case .notRegistered:
            return .notRegistered
        case .enabled:
            return .enabled
        case .requiresApproval:
            return .requiresApproval
        case .notFound:
            return .notFound
        @unknown default:
            return .notFound
        }
    }

    func setEnabled(_ isEnabled: Bool) throws -> State {
        if isEnabled {
            try SMAppService.mainApp.register()
        } else {
            try SMAppService.mainApp.unregister()
        }
        return currentState()
    }
}
