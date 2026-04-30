import AppKit
import Foundation

final class FileActionService {
    private let fileManager: FileManager
    private let uniqueURLResolver: UniqueFileURLResolver

    init(fileManager: FileManager = .default) {
        self.fileManager = fileManager
        uniqueURLResolver = UniqueFileURLResolver(fileManager: fileManager)
    }

    @discardableResult
    func createFile(named filename: String, from template: NewFileTemplate, in directory: URL) throws -> URL {
        try validateDirectory(directory)

        let trimmedName = filename.trimmingCharacters(in: .whitespacesAndNewlines)
        guard !trimmedName.isEmpty, !trimmedName.contains("/") else {
            throw RightKitError.invalidFilename(filename)
        }

        let proposedURL = directory.appendingPathComponent(trimmedName)
        let targetURL = uniqueURLResolver.availableURL(for: proposedURL)
        let data = Data(template.initialContent.utf8)
        try data.write(to: targetURL, options: .withoutOverwriting)
        return targetURL
    }

    func copyItems(at sourceURLs: [URL], to directory: URL) throws -> [URL] {
        try validateDirectory(directory)
        return try sourceURLs.map { sourceURL in
            try validateSource(sourceURL)
            let proposedURL = directory.appendingPathComponent(sourceURL.lastPathComponent)
            let targetURL = uniqueURLResolver.availableURL(for: proposedURL)
            try fileManager.copyItem(at: sourceURL, to: targetURL)
            return targetURL
        }
    }

    func moveItems(at sourceURLs: [URL], to directory: URL) throws -> [URL] {
        try validateDirectory(directory)
        return try sourceURLs.map { sourceURL in
            try validateSource(sourceURL)
            let proposedURL = directory.appendingPathComponent(sourceURL.lastPathComponent)
            let targetURL = uniqueURLResolver.availableURL(for: proposedURL)
            try fileManager.moveItem(at: sourceURL, to: targetURL)
            return targetURL
        }
    }

    func writePathsToPasteboard(_ urls: [URL]) throws {
        let text = urls.map(\.path).joined(separator: "\n")
        NSPasteboard.general.clearContents()
        let didWrite = NSPasteboard.general.setString(text, forType: .string)
        if !didWrite {
            throw RightKitError.pasteboardWriteFailed
        }
    }

    func urls(from state: CutPasteState?) throws -> [URL] {
        guard let state, !state.isEmpty else {
            throw RightKitError.emptyCutState
        }
        return state.sourcePaths.map { URL(fileURLWithPath: $0) }
    }

    private func validateDirectory(_ url: URL) throws {
        var isDirectory: ObjCBool = false
        let exists = fileManager.fileExists(atPath: url.path, isDirectory: &isDirectory)
        guard exists, isDirectory.boolValue else {
            throw RightKitError.directoryDoesNotExist(url.path)
        }
    }

    private func validateSource(_ url: URL) throws {
        guard fileManager.fileExists(atPath: url.path) else {
            throw RightKitError.sourceDoesNotExist(url.path)
        }
    }
}
