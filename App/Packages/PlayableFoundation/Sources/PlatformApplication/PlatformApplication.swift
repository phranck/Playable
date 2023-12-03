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
                if let error {
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

// swiftlint: disable force_unwrapping
public extension NSApplication {
    internal var infoPlistDictionary: [String: Any] {
        Bundle.main.infoDictionary!
    }

    static var appName: String {
        shared.infoPlistDictionary["CFBundleName"] as? String ?? "n/a"
    }

    static var version: String {
        shared.infoPlistDictionary["CFBundleShortVersionString"] as? String ?? "n/a"
    }

    static var buildNumber: String {
        shared.infoPlistDictionary["CFBundleVersion"] as? String ?? "n/a"
    }
}
// swiftlint: enable force_unwrapping
