//
// Playable - 🎧
// This file is part of the Playable project.
// Copyright (c) 2015-2022 Woodbytes, <phranck@mac.com>
//
// Created by: Frank Gregor
// Created at: 08.12.22
//

import ParseSwift
import PlayableFoundation
import SwiftUI

public struct ErrorHandler : Sendable{
    public static let shared = ErrorHandler()
    private init() {}

    // MARK: - Public API
    public static func handle(error: ParseError) {
        log.error(error)

        switch error.code {
            case .invalidSessionToken:
                shared.handleInvalidSessionToken()
            default:
                break
        }
    }
}

// MARK: - Private API

private extension ErrorHandler {
    func handleInvalidSessionToken() {
        PlayableParseUser.logout { result in
            switch result {
                case .success:
                    log.debug("User successfully logged out")

                case .failure(let error):
                    log.error("User logout with failure: \(error)")
            }
        }

        // If we are an anon user, we don't need to login again
        if PlayableParseUser.isAnonymous {
            return
        }
    }
}
