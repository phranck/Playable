import PlayableCore

/// Where the local Playable database file belongs on the running system.
///
/// macOS and Linux disagree about which directory holds application data, and
/// the module that opens the database must not be the module that knows the
/// difference. The app passes in the directory its platform considers correct,
/// and this type owns everything after that: the file name, the requirement
/// that the path be absolute, and the failure raised when it is not.
public struct StoreLocation: Equatable, Sendable {
    /// The file name every Playable installation uses.
    ///
    /// Held here rather than at the call site so that a rename reaches the
    /// database, its backups and its recovery path together.
    public static let databaseFileName = "playable.sqlite"

    /// The absolute path of the database file.
    public let databasePath: String

    /// Derives the database location from a platform application-data directory.
    ///
    /// - Parameter applicationDataDirectory: An absolute path to the directory
    ///   the platform reserves for this application's data. On macOS that is
    ///   below Application Support, on Linux below the XDG data home. A
    ///   trailing separator is accepted and removed.
    /// - Throws: ``PlayableError`` with code `storage` when the given directory
    ///   is not an absolute path to a named directory. A relative path would
    ///   silently resolve against whichever directory the process started in,
    ///   which puts the database somewhere different on every launch.
    public init(applicationDataDirectory: String) throws {
        guard let directory = Self.normalizedDirectory(applicationDataDirectory) else {
            throw PlayableError(
                code: .storage,
                message: "Local data could not be opened because its location is not a full path."
            )
        }

        databasePath = "\(directory)/\(Self.databaseFileName)"
    }
}

// MARK: - Path handling

private extension StoreLocation {
    /// Returns the directory without its trailing separator, or `nil` when it
    /// is not an absolute path to a named directory.
    static func normalizedDirectory(_ directory: String) -> String? {
        guard directory.hasPrefix("/") else { return nil }

        var normalized = directory
        while normalized.hasSuffix("/") {
            normalized.removeLast()
        }

        return normalized.isEmpty ? nil : normalized
    }
}
