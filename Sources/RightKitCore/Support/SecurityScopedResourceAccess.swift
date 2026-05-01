import Foundation

enum SecurityScopedBookmark {
    struct Resolution {
        let url: URL
        let refreshedBookmarkData: Data?
    }

    static func make(for url: URL) -> Data? {
        try? url.bookmarkData(
            options: [.withSecurityScope],
            includingResourceValuesForKeys: nil,
            relativeTo: nil
        )
    }

    static func resolve(from bookmarkData: Data) -> Resolution? {
        var isStale = false
        guard let url = try? URL(
            resolvingBookmarkData: bookmarkData,
            options: [.withSecurityScope, .withoutImplicitStartAccessing, .withoutUI],
            relativeTo: nil,
            bookmarkDataIsStale: &isStale
        ) else {
            return nil
        }

        let refreshedBookmarkData = isStale ? make(for: url) : nil
        return Resolution(url: url, refreshedBookmarkData: refreshedBookmarkData)
    }
}

enum SecurityScopedResourceAccess {
    static func withAccess<T>(to urls: [URL], _ body: () throws -> T) rethrows -> T {
        let scopedResources = urls.map { url in
            (url, url.startAccessingSecurityScopedResource())
        }

        defer {
            for (url, didAccess) in scopedResources.reversed() where didAccess {
                url.stopAccessingSecurityScopedResource()
            }
        }

        return try body()
    }
}
