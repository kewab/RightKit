import AppKit
import Foundation

final class FileActionService {
    private let fileManager: FileManager
    private let uniqueURLResolver: UniqueFileURLResolver
    private let logger = RightKitLogger.fileActions

    init(fileManager: FileManager = .default) {
        self.fileManager = fileManager
        uniqueURLResolver = UniqueFileURLResolver(fileManager: fileManager)
    }

    @discardableResult
    func createFile(named filename: String, from template: NewFileTemplate, in directory: URL) throws -> URL {
        try SecurityScopedResourceAccess.withAccess(to: [directory]) {
            let trimmedName = filename.trimmingCharacters(in: .whitespacesAndNewlines)
            guard !trimmedName.isEmpty, !trimmedName.contains("/") else {
                throw RightKitError.invalidFilename(filename)
            }

            let proposedURL = directory.appendingPathComponent(trimmedName)
            let targetURL = uniqueURLResolver.availableURL(for: proposedURL)
            let data = Data(template.initialContent.utf8)
            do {
                try data.write(to: targetURL, options: .withoutOverwriting)
            } catch {
                throw mapCreateFileError(error, directory: directory)
            }
            logger.info("Created file at \(targetURL.path, privacy: .public)")
            return targetURL
        }
    }

    func copyItems(at sourceURLs: [URL], to directory: URL) throws -> [URL] {
        try SecurityScopedResourceAccess.withAccess(to: sourceURLs + [directory]) {
            return try sourceURLs.map { sourceURL in
                let proposedURL = directory.appendingPathComponent(sourceURL.lastPathComponent)
                let targetURL = uniqueURLResolver.availableURL(for: proposedURL)
                do {
                    try fileManager.copyItem(at: sourceURL, to: targetURL)
                } catch {
                    throw mapFileOperationError(error, sourceURL: sourceURL, directory: directory)
                }
                logger.info("Copied item from \(sourceURL.path, privacy: .public) to \(targetURL.path, privacy: .public)")
                return targetURL
            }
        }
    }

    func moveItems(at sourceURLs: [URL], to directory: URL) throws -> [URL] {
        try SecurityScopedResourceAccess.withAccess(to: sourceURLs + [directory]) {
            return try sourceURLs.map { sourceURL in
                let proposedURL = directory.appendingPathComponent(sourceURL.lastPathComponent)
                let targetURL = uniqueURLResolver.availableURL(for: proposedURL)
                do {
                    try fileManager.moveItem(at: sourceURL, to: targetURL)
                } catch {
                    throw mapFileOperationError(error, sourceURL: sourceURL, directory: directory)
                }
                logger.info("Moved item from \(sourceURL.path, privacy: .public) to \(targetURL.path, privacy: .public)")
                return targetURL
            }
        }
    }

    func writePathsToPasteboard(_ urls: [URL]) throws {
        let text = urls.map(\.path).joined(separator: "\n")
        NSPasteboard.general.clearContents()
        let didWrite = NSPasteboard.general.setString(text, forType: .string)
        if !didWrite {
            throw RightKitError.pasteboardWriteFailed
        }
        logger.info("Copied \(urls.count) path(s) to pasteboard")
    }

    func urls(from state: CutPasteState?) throws -> [URL] {
        guard let state, !state.isEmpty else {
            throw RightKitError.emptyCutState
        }
        return state.sourcePaths.map { path in
            guard let bookmarkData = state.securityScopedBookmarks?[path],
                  let resolution = SecurityScopedBookmark.resolve(from: bookmarkData) else {
                return URL(fileURLWithPath: path)
            }
            return resolution.url
        }
    }

    private func mapCreateFileError(_ error: Error, directory: URL) -> Error {
        let nsError = error as NSError
        guard isNoSuchFileError(nsError),
              !directoryExists(at: directory) else {
            return error
        }
        return RightKitError.directoryDoesNotExist(directory.path)
    }

    private func mapFileOperationError(_ error: Error, sourceURL: URL, directory: URL) -> Error {
        let nsError = error as NSError
        guard isNoSuchFileError(nsError) else {
            return error
        }

        if !fileManager.fileExists(atPath: sourceURL.path) {
            return RightKitError.sourceDoesNotExist(sourceURL.path)
        }

        if !directoryExists(at: directory) {
            return RightKitError.directoryDoesNotExist(directory.path)
        }

        return error
    }

    private func directoryExists(at url: URL) -> Bool {
        var isDirectory: ObjCBool = false
        let exists = fileManager.fileExists(atPath: url.path, isDirectory: &isDirectory)
        return exists && isDirectory.boolValue
    }

    private func isNoSuchFileError(_ error: NSError) -> Bool {
        guard error.domain == NSCocoaErrorDomain else {
            return false
        }

        return [
            CocoaError.Code.fileNoSuchFile.rawValue,
            CocoaError.Code.fileReadNoSuchFile.rawValue
        ].contains(error.code)
    }
}
