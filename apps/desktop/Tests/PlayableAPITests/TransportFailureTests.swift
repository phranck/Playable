import PlayableCore
import Testing
@testable import PlayableAPI

@Suite("TransportFailure")
struct TransportFailureTests {
    @Test("reports no failure for a successful status", arguments: [200, 201, 204, 304])
    func successfulStatusProducesNoError(statusCode: Int) {
        #expect(TransportFailure.fromStatusCode(statusCode) == nil)
    }

    @Test("maps a rejected session to unauthorized", arguments: [401, 403])
    func rejectedSessionMapsToUnauthorized(statusCode: Int) {
        #expect(TransportFailure.fromStatusCode(statusCode)?.code == .unauthorized)
    }

    @Test("maps a missing or withdrawn item to notFound", arguments: [404, 410])
    func missingItemMapsToNotFound(statusCode: Int) {
        #expect(TransportFailure.fromStatusCode(statusCode)?.code == .notFound)
    }

    @Test("maps a late answer to timedOut", arguments: [408, 504])
    func lateAnswerMapsToTimedOut(statusCode: Int) {
        #expect(TransportFailure.fromStatusCode(statusCode)?.code == .timedOut)
    }

    @Test("maps every other failing status to server", arguments: [400, 418, 429, 500, 503])
    func otherFailingStatusMapsToServer(statusCode: Int) {
        #expect(TransportFailure.fromStatusCode(statusCode)?.code == .server)
    }

    @Test("carries the backend error identifier through")
    func keepsErrorIdentifier() {
        #expect(TransportFailure.fromStatusCode(500, errorID: "e-17")?.errorID == "e-17")
    }

    @Test("maps an unreachable platform to offline")
    func unreachableMapsToOffline() {
        let error = TransportFailure.fromInterruption(.unreachable)

        #expect(error.code == .offline)
        #expect(error.isRetryable)
    }

    @Test("maps a missing answer to timedOut")
    func noAnswerMapsToTimedOut() {
        #expect(TransportFailure.fromInterruption(.noAnswerInTime).code == .timedOut)
    }
}
