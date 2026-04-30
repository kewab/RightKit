import Foundation

struct NewFileTemplate: Identifiable, Codable, Hashable {
    var id: UUID
    var title: String
    var fileExtension: String
    var initialContent: String

    init(id: UUID = UUID(), title: String, fileExtension: String, initialContent: String = "") {
        self.id = id
        self.title = title
        self.fileExtension = fileExtension
        self.initialContent = initialContent
    }

    var suggestedFilename: String {
        "Untitled.\(fileExtension)"
    }

    static let defaults: [NewFileTemplate] = [
        NewFileTemplate(title: "Text", fileExtension: "txt"),
        NewFileTemplate(title: "Markdown", fileExtension: "md", initialContent: "# Untitled\n"),
        NewFileTemplate(title: "JSON", fileExtension: "json", initialContent: "{\n  \n}\n")
    ]
}
