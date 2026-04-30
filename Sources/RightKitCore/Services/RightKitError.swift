import Foundation

enum RightKitError: LocalizedError {
    case directoryDoesNotExist(String)
    case sourceDoesNotExist(String)
    case invalidFilename(String)
    case pasteboardWriteFailed
    case emptyCutState

    var errorDescription: String? {
        switch self {
        case .directoryDoesNotExist(let path):
            return "Directory does not exist: \(path)"
        case .sourceDoesNotExist(let path):
            return "Source item does not exist: \(path)"
        case .invalidFilename(let name):
            return "Invalid filename: \(name)"
        case .pasteboardWriteFailed:
            return "Failed to write paths to pasteboard."
        case .emptyCutState:
            return "No cut items are waiting to be pasted."
        }
    }
}
