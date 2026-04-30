import Foundation

struct FavoriteDirectory: Identifiable, Codable, Hashable {
    var id: UUID
    var name: String
    var path: String
    var bookmarkData: Data?

    init(id: UUID = UUID(), name: String, path: String, bookmarkData: Data? = nil) {
        self.id = id
        self.name = name
        self.path = path
        self.bookmarkData = bookmarkData
    }

    var url: URL {
        URL(fileURLWithPath: path)
    }

    var resolvedURL: URL {
        guard let bookmarkData else {
            return url
        }

        var isStale = false
        guard let resolvedURL = try? URL(
            resolvingBookmarkData: bookmarkData,
            options: [.withSecurityScope],
            relativeTo: nil,
            bookmarkDataIsStale: &isStale
        ) else {
            return url
        }

        return resolvedURL
    }
}
