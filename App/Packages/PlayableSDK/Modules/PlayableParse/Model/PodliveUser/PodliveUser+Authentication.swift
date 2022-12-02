//
// Playable - 🎧
// This file is part of the Playable project.
// Copyright (c) 2015-2022 Woodbytes, <phranck@mac.com>
//
// Created by: Frank Gregor
// Created at: 02.12.22
//

import Foundation
import ParseSwift
import PlayableFoundation

public extension PlayableParseUser {
    static func anonymousLogin() {
        log.debug("Will login as anonymous user")

        anonymous.login { result in
            switch result {
            case .success(let user):
                log.debug("Logged in as anonymous user: \(user)")
                NotificationCenter.default.post(name: Notification.Name.updateUser, object: nil)

            case .failure(let error):
                log.error("Could not login as anonymous user: \(error)")
            }
        }
    }
}
