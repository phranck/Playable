//
// Playable - 🎧
// This file is part of the Playable project.
// Copyright (c) 2015-2022 Woodbytes, <phranck@mac.com>
//
// Created by: Frank Gregor
// Created at: 02.12.22
//

import Foundation
import PlayableFoundation

public extension PlayableParseInstallation {
    func save(user: PlayableParseUser, completion: @escaping EmptyClosure) {
        guard var installation = PlayableParseInstallation.current else {
            syncWithBackend {
                save(user: user, completion: completion)
            }
            return
        }

        if installation.isSaved {
            installation = installation.mergeable
        }
        installation.user = user

        installation.save { result in
            switch result {
                case .success(let installation):
                    log.debug("Installation with id: '\(installation.id)' for user with id: '\(user.id)' successfully saved.")

                case .failure(let error):
                    log.error("Error while saving installation: \(error.localizedDescription)")
            }

            completion()
        }
    }

    func syncWithBackend(completion: @escaping EmptyClosure = {}) {
        guard let installation = PlayableParseInstallation.current else {
            completion()
            return
        }

        installation.fetch { result in
            switch result {
                case .success:
                    log.debug("Sucessfully synced installation from backend.")
                    completion()

                case .failure(let error):
                    fatalError(error.localizedDescription)
            }
        }
    }
}
