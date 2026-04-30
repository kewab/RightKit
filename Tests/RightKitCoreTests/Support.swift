import Foundation

struct TestCase {
    let name: String
    let body: () throws -> Void
}

enum TestFailure: Error, CustomStringConvertible {
    case message(String)

    var description: String {
        switch self {
        case .message(let message):
            return message
        }
    }
}

@discardableResult
func expect(_ condition: @autoclosure () -> Bool, _ message: String) throws -> Bool {
    if !condition() {
        throw TestFailure.message(message)
    }
    return true
}

func expectEqual<T: Equatable>(_ lhs: T, _ rhs: T, _ message: String) throws {
    try expect(lhs == rhs, "\(message). Expected \(rhs), got \(lhs)")
}

func expectThrows(
    _ message: String,
    _ block: () throws -> Void,
    validate: (Error) throws -> Void
) throws {
    do {
        try block()
        throw TestFailure.message("\(message). Expected error but nothing was thrown")
    } catch {
        try validate(error)
    }
}

struct TemporaryDirectory {
    let url: URL

    init() throws {
        let baseURL = FileManager.default.temporaryDirectory
        url = baseURL.appendingPathComponent(UUID().uuidString, isDirectory: true)
        try FileManager.default.createDirectory(at: url, withIntermediateDirectories: true)
    }

    func createSubdirectory(named name: String) throws -> URL {
        let directoryURL = url.appendingPathComponent(name, isDirectory: true)
        try FileManager.default.createDirectory(at: directoryURL, withIntermediateDirectories: true)
        return directoryURL
    }
}

struct UserDefaultsFixture {
    let suiteName: String

    init() {
        suiteName = "RightKitTests.\(UUID().uuidString)"
        UserDefaults(suiteName: suiteName)?.removePersistentDomain(forName: suiteName)
    }
}
