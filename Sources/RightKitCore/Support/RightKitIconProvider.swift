import AppKit
import Foundation
import UniformTypeIdentifiers

enum RightKitIconProvider {
    static func templateIcon(for template: NewFileTemplate, size: CGFloat = 20) -> NSImage {
        if let type = UTType(filenameExtension: template.fileExtension) {
            return sized(NSWorkspace.shared.icon(for: type), size: size)
        }

        return sized(NSWorkspace.shared.icon(forFileType: template.fileExtension), size: size)
    }

    static func directoryIcon(for url: URL, size: CGFloat = 20) -> NSImage {
        sized(NSWorkspace.shared.icon(forFile: url.path), size: size)
    }

    static func symbol(
        _ systemName: String,
        pointSize: CGFloat = 17,
        weight: NSFont.Weight = .regular
    ) -> NSImage? {
        let configuration = NSImage.SymbolConfiguration(pointSize: pointSize, weight: weight)
        let image = NSImage(systemSymbolName: systemName, accessibilityDescription: nil)
        return image?.withSymbolConfiguration(configuration) ?? image
    }

    private static func sized(_ image: NSImage, size: CGFloat) -> NSImage {
        let copy = (image.copy() as? NSImage) ?? image
        copy.size = NSSize(width: size, height: size)
        return copy
    }
}
