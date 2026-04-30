import Foundation

func makeUniqueFileURLResolverTests() -> [TestCase] {
    [
        TestCase(name: "UniqueFileURLResolver returns proposed URL when file does not exist") {
            let fixture = try TemporaryDirectory()
            let resolver = UniqueFileURLResolver()
            let proposedURL = fixture.url.appendingPathComponent("Report.txt")

            let resolvedURL = resolver.availableURL(for: proposedURL)

            try expectEqual(resolvedURL, proposedURL, "Resolver should keep the original URL")
        },
        TestCase(name: "UniqueFileURLResolver appends copy suffix for duplicate files") {
            let fixture = try TemporaryDirectory()
            let resolver = UniqueFileURLResolver()
            let originalURL = fixture.url.appendingPathComponent("Report.txt")
            FileManager.default.createFile(atPath: originalURL.path, contents: Data(), attributes: nil)

            let resolvedURL = resolver.availableURL(for: originalURL)

            try expectEqual(resolvedURL.lastPathComponent, "Report copy.txt", "Resolver should append the first copy suffix")
        },
        TestCase(name: "UniqueFileURLResolver increments copy suffix until an available name is found") {
            let fixture = try TemporaryDirectory()
            let resolver = UniqueFileURLResolver()
            let originalURL = fixture.url.appendingPathComponent("Report.txt")
            let duplicateURL = fixture.url.appendingPathComponent("Report copy.txt")
            FileManager.default.createFile(atPath: originalURL.path, contents: Data(), attributes: nil)
            FileManager.default.createFile(atPath: duplicateURL.path, contents: Data(), attributes: nil)

            let resolvedURL = resolver.availableURL(for: originalURL)

            try expectEqual(resolvedURL.lastPathComponent, "Report copy 2.txt", "Resolver should keep incrementing suffixes")
        }
    ]
}
