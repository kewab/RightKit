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

    var bookmarkResolution: SecurityScopedBookmark.Resolution? {
        guard let bookmarkData else {
            return nil
        }

        return SecurityScopedBookmark.resolve(from: bookmarkData)
    }

    var resolvedURL: URL {
        bookmarkResolution?.url ?? url
    }
}
