import PlayableCore
import Testing
@testable import PlayableStore

@Suite("StoreLocation")
struct StoreLocationTests {
    @Test("puts the database inside the given directory")
    func buildsPathBelowDirectory() throws {
        let location = try StoreLocation(applicationDataDirectory: "/Users/someone/Library/Application Support/Playable")

        #expect(location.databasePath == "/Users/someone/Library/Application Support/Playable/playable.sqlite")
    }

    @Test("accepts a trailing separator without doubling it")
    func removesTrailingSeparator() throws {
        let location = try StoreLocation(applicationDataDirectory: "/home/someone/.local/share/playable/")

        #expect(location.databasePath == "/home/someone/.local/share/playable/playable.sqlite")
    }

    @Test("rejects a relative directory")
    func rejectsRelativeDirectory() {
        #expect(throws: PlayableError.self) {
            try StoreLocation(applicationDataDirectory: "Library/Application Support/Playable")
        }
    }

    @Test("rejects a directory without a name", arguments: ["", "/", "///"])
    func rejectsUnnamedDirectory(directory: String) {
        #expect(throws: PlayableError.self) {
            try StoreLocation(applicationDataDirectory: directory)
        }
    }

    @Test("reports a rejected directory as a storage failure")
    func rejectionUsesStorageCode() {
        do {
            _ = try StoreLocation(applicationDataDirectory: "relative/path")
            Issue.record("A relative directory must not produce a location")
        } catch let error as PlayableError {
            #expect(error.code == .storage)
            #expect(!error.isRetryable)
        } catch {
            Issue.record("Expected a PlayableError, got \(error)")
        }
    }

    @Test("uses one file name for every installation")
    func usesSharedFileName() throws {
        let location = try StoreLocation(applicationDataDirectory: "/tmp/playable-test")

        #expect(location.databasePath.hasSuffix(StoreLocation.databaseFileName))
    }
}
