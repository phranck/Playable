/// The single failure value every Playable layer reports upwards.
///
/// Both desktop apps present failures the same way, so transport failures,
/// store failures and rejected requests have to arrive in one shape. Each layer
/// translates its own failures into this value at its boundary, which keeps
/// `URLError`, SQLite result codes and HTTP status numbers out of the layers
/// above it.
///
/// - Note: ``message`` is shown to a person. It never carries a URL, a token or
///   a database path, because the same value is written to logs the user may
///   send in with a report.
public struct PlayableError: Error, Equatable, Sendable {
    /// The stable machine-readable reason, used for branching and for logs.
    public let code: Code

    /// A short safe sentence describing the failure to a person.
    public let message: String

    /// The identifier the backend assigned to this failure, when it reported one.
    ///
    /// The value is echoed in the interface so a report can be matched against a
    /// server log entry. Failures that never reached the backend carry `nil`.
    public let errorID: String?

    /// Whether repeating the same operation unchanged can plausibly succeed.
    ///
    /// Callers use this to decide between offering a retry and reporting a dead
    /// end. It is derived from ``code`` so the two cannot disagree.
    public var isRetryable: Bool { code.isRetryable }

    /// Creates a failure value with the standard wording for its reason.
    ///
    /// This is the initialiser the adapters use. Taking the wording from the
    /// reason keeps one failure reading the same way wherever it surfaces.
    ///
    /// - Parameters:
    ///   - code: The stable reason for the failure.
    ///   - errorID: The backend-assigned identifier, or `nil` when the failure
    ///     never reached the backend.
    public init(code: Code, errorID: String? = nil) {
        self.init(code: code, message: code.defaultMessage, errorID: errorID)
    }

    /// Creates a failure value with wording of its own.
    ///
    /// Reserved for failures where the platform sent a safe sentence that says
    /// more than the standard one.
    ///
    /// - Parameters:
    ///   - code: The stable reason for the failure.
    ///   - message: A safe sentence for a person. Must not contain credentials,
    ///     full URLs or file system paths.
    ///   - errorID: The backend-assigned identifier, or `nil` when the failure
    ///     never reached the backend.
    public init(code: Code, message: String, errorID: String? = nil) {
        self.code = code
        self.message = message
        self.errorID = errorID
    }
}

// MARK: - Code

public extension PlayableError {
    /// The stable reasons a Playable operation can fail for.
    ///
    /// The set is deliberately small. A caller branches on the reason to decide
    /// what to offer the person, so a distinction that leads to the same offer
    /// does not earn a case of its own.
    enum Code: String, CaseIterable, Sendable {
        /// The device could not reach the Playable platform at all.
        case offline

        /// The platform was reached but did not answer in time.
        case timedOut

        /// The platform answered with a failure of its own.
        case server

        /// The request was rejected because the session is missing or expired.
        case unauthorized

        /// The requested item does not exist, or is no longer published.
        case notFound

        /// Local storage could not be read or written.
        case storage

        /// The answer did not match the agreed contract.
        case malformedResponse

        /// Whether repeating the same operation unchanged can plausibly succeed.
        ///
        /// A rejected session, a missing item and a broken contract stay broken
        /// however often they are asked for, so only the transport and server
        /// failures are worth a second attempt.
        public var isRetryable: Bool {
            switch self {
            case .offline, .timedOut, .server:
                return true
            case .unauthorized, .notFound, .storage, .malformedResponse:
                return false
            }
        }

        /// The safe sentence shown when a layer reports this reason.
        ///
        /// The wording lives beside the reason rather than in each adapter,
        /// because every adapter that maps into ``PlayableError`` would
        /// otherwise carry its own copy of the same table. The app layer
        /// replaces these strings with localized ones, which is why none of
        /// them interpolates a detail.
        public var defaultMessage: String {
            switch self {
            case .offline:
                return "Playable could not be reached."
            case .timedOut:
                return "Playable did not answer in time."
            case .server:
                return "Playable reported a problem."
            case .unauthorized:
                return "This session is no longer signed in."
            case .notFound:
                return "This item is not available."
            case .storage:
                return "Local data could not be read."
            case .malformedResponse:
                return "Playable sent an unexpected answer."
            }
        }
    }
}
