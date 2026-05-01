import Foundation

struct CutPasteState: Codable, Equatable {
    var sourcePaths: [String]
    var securityScopedBookmarks: [String: Data]?
    var createdAt: Date

    init(
        sourcePaths: [String],
        securityScopedBookmarks: [String: Data]? = nil,
        createdAt: Date = Date()
    ) {
        self.sourcePaths = sourcePaths
        self.securityScopedBookmarks = securityScopedBookmarks
        self.createdAt = createdAt
    }

    var isEmpty: Bool {
        sourcePaths.isEmpty
    }
}
