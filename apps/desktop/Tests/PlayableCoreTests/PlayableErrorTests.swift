import Testing
@testable import PlayableCore

@Suite("PlayableError")
struct PlayableErrorTests {
    @Test("takes the standard wording from its reason")
    func usesDefaultMessageForCode() {
        let error = PlayableError(code: .offline)

        #expect(error.message == PlayableError.Code.offline.defaultMessage)
        #expect(error.errorID == nil)
    }

    @Test("keeps wording supplied by the caller")
    func keepsExplicitMessage() {
        let error = PlayableError(code: .server, message: "The live catalog is being rebuilt.", errorID: "e-42")

        #expect(error.message == "The live catalog is being rebuilt.")
        #expect(error.errorID == "e-42")
    }

    @Test("reports retryability from its reason alone")
    func derivesRetryabilityFromCode() {
        #expect(PlayableError(code: .timedOut).isRetryable)
        #expect(!PlayableError(code: .unauthorized).isRetryable)
    }

    @Test("gives every reason a non-empty sentence")
    func everyCodeHasAMessage() {
        for code in PlayableError.Code.allCases {
            #expect(!code.defaultMessage.isEmpty, "\(code.rawValue) has no default message")
        }
    }

    @Test("keeps credentials and locations out of the standard wording")
    func defaultMessagesStaySafe() {
        for code in PlayableError.Code.allCases {
            let message = code.defaultMessage
            #expect(!message.contains("://"), "\(code.rawValue) leaks a URL")
            #expect(!message.contains("/"), "\(code.rawValue) leaks a path")
        }
    }
}
