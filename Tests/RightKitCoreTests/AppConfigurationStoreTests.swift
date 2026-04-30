import Foundation

func makeAppConfigurationStoreTests() -> [TestCase] {
    [
        TestCase(name: "AppConfigurationStore saves and loads favorite directories in order") {
            let fixture = UserDefaultsFixture()
            let store = AppConfigurationStore(suiteName: fixture.suiteName)
            let bookmarkA = Data([0x01, 0x02])
            let bookmarkB = Data([0x03, 0x04])
            let directories = [
                FavoriteDirectory(
                    id: UUID(uuidString: "00000000-0000-0000-0000-000000000001")!,
                    name: "Work",
                    path: "/tmp/work",
                    bookmarkData: bookmarkA
                ),
                FavoriteDirectory(
                    id: UUID(uuidString: "00000000-0000-0000-0000-000000000002")!,
                    name: "Desktop",
                    path: "/tmp/desktop",
                    bookmarkData: bookmarkB
                )
            ]

            store.saveFavoriteDirectories(directories)

            try expectEqual(store.loadFavoriteDirectories(), directories, "Favorite directories should preserve order and content")
        },
        TestCase(name: "AppConfigurationStore returns default templates when nothing was saved") {
            let fixture = UserDefaultsFixture()
            let store = AppConfigurationStore(suiteName: fixture.suiteName)

            try expectEqual(store.loadFileTemplates(), NewFileTemplate.defaults, "Default templates should be returned for a fresh store")
        },
        TestCase(name: "AppConfigurationStore saves and clears cut paste state") {
            let fixture = UserDefaultsFixture()
            let store = AppConfigurationStore(suiteName: fixture.suiteName)
            let state = CutPasteState(
                sourcePaths: ["/tmp/a.txt"],
                createdAt: Date(timeIntervalSince1970: 1234)
            )

            store.saveCutPasteState(state)
            try expectEqual(store.loadCutPasteState(), state, "Saved cut state should load back unchanged")

            store.saveCutPasteState(nil)
            try expect(store.loadCutPasteState() == nil, "Cut state should be cleared when nil is saved")
        },
        TestCase(name: "AppConfigurationStore saves and loads language") {
            let fixture = UserDefaultsFixture()
            let store = AppConfigurationStore(suiteName: fixture.suiteName)

            store.saveLanguage(.english)

            try expectEqual(store.loadLanguage(), .english, "Saved language should load back unchanged")
        }
    ]
}
