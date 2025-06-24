//
// Playable - 🎧
// This file is part of the Playable project.
// Copyright (c) 2015-2022 Woodbytes, <phranck@mac.com>
//
// Created by: Frank Gregor
// Created at: 01.12.22
//

import Foundation
import ParseSwift
import PlayableFoundation

public extension Parse {
    static func setup() {
        let parseApplicationId = Bundle.parseApplicationId
        let parseClientKey = Bundle.parseClientKey
        let parseServerUrl = Bundle.parseServerUrl

        log.debug("Parse Setup: begin\n---\nApplicationId: \(parseApplicationId)\nClientKey: \(parseClientKey)\nServer URL: \(parseServerUrl)\n---\n")

        ParseSwift.initialize(
            applicationId: parseApplicationId,
            clientKey: parseClientKey,
            serverURL: parseServerUrl
        )

        log.debug("Parse Setup: done")
    }

    @MainActor
    static func setupParseUser() {
        guard let user = PlayableParseUser.current else {
            PlayableParseUser.anonymousLogin()
            return
        }

        user.syncDataFromBackend {
        }
    }
}
