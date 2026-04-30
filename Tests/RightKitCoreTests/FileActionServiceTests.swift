import Foundation

func makeFileActionServiceTests() -> [TestCase] {
    [
        TestCase(name: "FileActionService createFile writes template content") {
            let fixture = try TemporaryDirectory()
            let service = FileActionService()
            let template = NewFileTemplate(title: "Markdown", fileExtension: "md", initialContent: "# Title\n")

            let createdURL = try service.createFile(
                named: "Notes.md",
                from: template,
                in: fixture.url
            )

            let content = try String(contentsOf: createdURL, encoding: .utf8)
            try expectEqual(createdURL.lastPathComponent, "Notes.md", "Created filename should match input")
            try expectEqual(content, "# Title\n", "Created file should contain template content")
        },
        TestCase(name: "FileActionService createFile rejects invalid filename") {
            let fixture = try TemporaryDirectory()
            let service = FileActionService()
            let template = NewFileTemplate(title: "Text", fileExtension: "txt")

            try expectThrows("Invalid filename should be rejected") {
                _ = try service.createFile(named: "bad/name.txt", from: template, in: fixture.url)
            } validate: { error in
                guard case RightKitError.invalidFilename(let filename) = error else {
                    throw TestFailure.message("Expected invalidFilename error, got \(error)")
                }
                try expectEqual(filename, "bad/name.txt", "Invalid filename payload should be preserved")
            }
        },
        TestCase(name: "FileActionService copyItems creates unique name when destination exists") {
            let fixture = try TemporaryDirectory()
            let service = FileActionService()
            let sourceURL = fixture.url.appendingPathComponent("source.txt")
            let destinationDirectory = try fixture.createSubdirectory(named: "Destination")
            let existingURL = destinationDirectory.appendingPathComponent("source.txt")

            try "first".write(to: sourceURL, atomically: true, encoding: .utf8)
            try "existing".write(to: existingURL, atomically: true, encoding: .utf8)

            let copiedURLs = try service.copyItems(at: [sourceURL], to: destinationDirectory)

            try expectEqual(copiedURLs.count, 1, "Exactly one file should be copied")
            try expectEqual(copiedURLs[0].lastPathComponent, "source copy.txt", "Duplicate destination should be renamed predictably")
            try expectEqual(try String(contentsOf: copiedURLs[0], encoding: .utf8), "first", "Copied file content should match source")
            try expectEqual(try String(contentsOf: existingURL, encoding: .utf8), "existing", "Existing destination file should remain unchanged")
        },
        TestCase(name: "FileActionService moveItems moves files into target directory") {
            let fixture = try TemporaryDirectory()
            let service = FileActionService()
            let sourceURL = fixture.url.appendingPathComponent("draft.txt")
            let destinationDirectory = try fixture.createSubdirectory(named: "Archive")

            try "payload".write(to: sourceURL, atomically: true, encoding: .utf8)

            let movedURLs = try service.moveItems(at: [sourceURL], to: destinationDirectory)

            try expectEqual(movedURLs.count, 1, "Exactly one file should be moved")
            try expectEqual(movedURLs[0].lastPathComponent, "draft.txt", "Moved filename should be preserved")
            try expect(FileManager.default.fileExists(atPath: movedURLs[0].path), "Moved file should exist at destination")
            try expect(!FileManager.default.fileExists(atPath: sourceURL.path), "Source file should be removed after move")
        },
        TestCase(name: "FileActionService urls rejects empty cut paste state") {
            let service = FileActionService()

            try expectThrows("Empty cut state should be rejected") {
                _ = try service.urls(from: CutPasteState(sourcePaths: []))
            } validate: { error in
                guard case RightKitError.emptyCutState = error else {
                    throw TestFailure.message("Expected emptyCutState error, got \(error)")
                }
            }
        },
        TestCase(name: "FileActionService urls builds file URLs from stored paths") {
            let service = FileActionService()
            let state = CutPasteState(sourcePaths: ["/tmp/a.txt", "/tmp/b.txt"])

            let urls = try service.urls(from: state)

            try expectEqual(urls.map(\.path), ["/tmp/a.txt", "/tmp/b.txt"], "Stored paths should round-trip as file URLs")
        }
    ]
}
