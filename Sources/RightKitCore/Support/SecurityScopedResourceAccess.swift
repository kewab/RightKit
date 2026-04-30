import Foundation

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
