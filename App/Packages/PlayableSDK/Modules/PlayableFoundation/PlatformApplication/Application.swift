//
// Playable - 🎧
// This file is part of the Playable project.
// Copyright (c) 2015-2022 Woodbytes, <phranck@mac.com>
//
// Created by: Frank Gregor
// Created at: 02.12.22
//

import SwiftUI
import UserNotifications

public extension NSApplication {
    static func registerForRemoteNotifications(completion: @escaping (Result<Bool, Error>) -> Void ) {
        let notificationCenter = UNUserNotificationCenter.current()

        notificationCenter.requestAuthorization(options: [.alert, .badge, .sound]) { _, error in
            DispatchQueue.main.async {
                if let error = error {
                    log.error("Error while requesting notification authorization: \(error.localizedDescription)")
                    completion(.failure(error))
                }
                else {
                    shared.registerForRemoteNotifications()
                    completion(.success(true))
                }
            }
        }
    }

    static func handleRemoteNotification(userInfo: [AnyHashable: Any]) {
    }
}
