import Foundation

let testCases =
    makeUniqueFileURLResolverTests() +
    makeFileActionServiceTests() +
    makeAppConfigurationStoreTests()

var failures: [(String, Error)] = []

for testCase in testCases {
    do {
        try testCase.body()
        print("PASS: \(testCase.name)")
    } catch {
        failures.append((testCase.name, error))
        print("FAIL: \(testCase.name)")
        print("  \(error)")
    }
}

print("")
print("Executed \(testCases.count) tests, \(failures.count) failed.")

if !failures.isEmpty {
    exit(1)
}
