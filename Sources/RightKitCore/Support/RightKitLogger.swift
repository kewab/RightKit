import OSLog

enum RightKitLogger {
    static let fileActions = Logger(
        subsystem: RightKitBundle.appIdentifier,
        category: "FileActions"
    )

    static let finderExtension = Logger(
        subsystem: RightKitBundle.finderExtensionIdentifier,
        category: "FinderSync"
    )
}
