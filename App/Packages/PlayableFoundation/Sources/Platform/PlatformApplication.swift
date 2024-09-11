//
// Cadrage Studio - 🎬
// This file is part of the Cadrage Studio project.
// Copyright (C) 2021-2022 Cadrage GmbH, <support@cadrage.app>
//
// Created by: Frank Gregor
// Created at: 08.11.22
//

import SwiftUI
import UserNotifications

public extension PlatformApplication {
    internal var infoPlistDictionary: [String: Any] {
        // swiftlint:disable force_unwrapping
        Bundle.main.infoDictionary!
    }

    static var name: String {
        PlatformApp.infoPlistDictionary["CFBundleName"] as? String ?? "n/a"
    }

    static var displayName: String {
        PlatformApp.infoPlistDictionary["CFBundleDisplayName"] as? String ?? "n/a"
    }

    static var version: String {
        PlatformApp.infoPlistDictionary["CFBundleShortVersionString"] as? String ?? "n/a"
    }

    static var buildNumber: String {
        PlatformApp.infoPlistDictionary["CFBundleVersion"] as? String ?? "n/a"
    }
}

public extension PlatformApplication {
    static func registerForRemoteNotifications(completion: @escaping (Result<Bool, Error>) -> Void ) {
        let nc = UNUserNotificationCenter.current()
        
        nc.requestAuthorization(options: [.alert, .badge, .sound]) { _, error in
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
