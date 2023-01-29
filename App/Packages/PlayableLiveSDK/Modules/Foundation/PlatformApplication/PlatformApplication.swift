// Playable - 🎧
// This file is part of the Playable project.
// Copyright (c) 2015-2022 Woodbytes, <phranck@mac.com>
//
// Created by: Frank Gregor
// Created at: 02.12.22
//

import SwiftUI
import UserNotifications

#if canImport(AppKit)
public typealias PlatformApplication = NSApplication
public typealias PlatformApplicationDelegate = NSApplicationDelegate
#elseif canImport(UIKit)
public typealias PlatformApplication = UIApplication
public typealias PlatformApplicationDelegate = UIApplicationDelegate
#endif

public extension PlatformApplication {
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

public extension PlatformApplication {
    // swiftlint: disable force_unwrapping
    internal var infoPlistDictionary: [String: Any] {
        Bundle.main.infoDictionary!
    }

    static var appName: String {
        PlatformApplication.shared.infoPlistDictionary["CFBundleName"] as? String ?? "n/a"
    }

    static var version: String {
        PlatformApplication.shared.infoPlistDictionary["CFBundleShortVersionString"] as? String ?? "n/a"
    }

    static var buildNumber: String {
        PlatformApplication.shared.infoPlistDictionary["CFBundleVersion"] as? String ?? "n/a"
    }
}
