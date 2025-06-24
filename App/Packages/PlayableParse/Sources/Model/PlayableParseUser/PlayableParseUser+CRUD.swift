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
import SwiftUI

public extension PlayableParseUser {
    @MainActor
    func syncDataFromBackend(completion: @escaping EmptyClosure = {}) {
        log.debug("Will sync user data from backend for user with id: \(id)")

        fetch { result in
            switch result {
            case .success(let user):
                guard user.channels?.count ?? 0 > 0 else {
                    log.debug("No channel subscriptions")
                    return
                }

                NSApplication.registerForRemoteNotifications { result in
                    switch result {
                        case .success:
                            log.debug("Successfully registered for Remote Notifications")

                        case .failure(let error):
                            log.error("Error while registering for Remote Notifications: \(error.localizedDescription)")
                    }
                }
                
            case .failure(let error):
                ErrorHandler.handle(error: error)
            }
        }
    }
}

// MARK: - Private API

private extension PlayableParseUser {
    @MainActor func handleSyncSuccess(for user: PlayableParseUser) {
        log.debug("Synced data from user with id: \(user.id)")

        guard user.channels?.count ?? 0 > 0 else {
            log.debug("No channel subscriptions")
            return
        }

        NSApplication.registerForRemoteNotifications { result in
            switch result {
                case .success:
                    log.debug("Successfully registered for Remote Notifications")

                case .failure(let error):
                    log.error("Error while registering for Remote Notifications: \(error.localizedDescription)")
            }
        }
    }
}
