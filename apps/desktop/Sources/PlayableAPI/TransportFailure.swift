import PlayableCore

/// Translates what the transport layer observed into a ``PlayableError``.
///
/// The generated OpenAPI client and its HTTP transport stay behind this module,
/// so this is the last point at which a status number exists. Everything above
/// it sees a ``PlayableError`` and never learns which transport produced it,
/// which is what lets macOS and Linux use different HTTP stacks.
public enum TransportFailure {
    /// Maps an HTTP status code to the failure a caller should see.
    ///
    /// - Parameters:
    ///   - statusCode: The status the platform answered with.
    ///   - errorID: The identifier from the platform's error body, when present.
    /// - Returns: The mapped failure, or `nil` when the status is a success and
    ///   therefore describes no failure at all.
    public static func fromStatusCode(_ statusCode: Int, errorID: String? = nil) -> PlayableError? {
        guard let code = errorCode(forStatusCode: statusCode) else { return nil }
        return PlayableError(code: code, errorID: errorID)
    }

    /// Maps a transport-level interruption to the failure a caller should see.
    ///
    /// - Parameter kind: What the transport observed before any status existed.
    /// - Returns: The mapped failure.
    public static func fromInterruption(_ kind: Interruption) -> PlayableError {
        switch kind {
        case .unreachable:
            return PlayableError(code: .offline)
        case .noAnswerInTime:
            return PlayableError(code: .timedOut)
        }
    }
}

// MARK: - Interruption

public extension TransportFailure {
    /// A failure that happened before the platform produced any status code.
    enum Interruption: Sendable {
        /// No route to the platform, so the request never arrived.
        case unreachable

        /// The request arrived but no answer came back in time.
        case noAnswerInTime
    }
}

// MARK: - Mapping

private extension TransportFailure {
    /// Reduces an HTTP status to a stable Playable reason.
    ///
    /// Anything below 400 is a success as far as failure reporting goes. Every
    /// unmapped failing status becomes `.server`, because a caller can do
    /// nothing with the distinction between one unexpected status and another.
    static func errorCode(forStatusCode statusCode: Int) -> PlayableError.Code? {
        switch statusCode {
        case ..<400:
            return nil
        case 401, 403:
            return .unauthorized
        case 404, 410:
            return .notFound
        case 408, 504:
            return .timedOut
        default:
            return .server
        }
    }
}
