import Foundation

struct CutPasteState: Codable, Equatable {
    var sourcePaths: [String]
    var createdAt: Date

    init(sourcePaths: [String], createdAt: Date = Date()) {
        self.sourcePaths = sourcePaths
        self.createdAt = createdAt
    }

    var isEmpty: Bool {
        sourcePaths.isEmpty
    }
}
