// Playable - 🎧
// This file is part of the Playable project.
// Copyright (c) 2015-2023 Woodbytes, <phranck@mac.com>
//
// Created by: Frank Gregor
// Created at: 12.01.23
//

import ParseSwift
import PlayableFoundation
import PlayableParse
import SwiftUI
import UserNotifications

class PlayableAppDelegate: NSObject, ApplicationDelegate {
    func application(_ application: Application, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
        log.debug("Device Token: \(String(describing: PlayableParseInstallation.current?.deviceToken))")

        guard
            var installation = PlayableParseInstallation.current,     // We have a valid installation...
            installation.deviceToken == nil                     // but no deviceToken...
        else {
            return
        }

        // so we have to set the curren token
        installation.setDeviceToken(deviceToken)
        installation.save { result in
            switch result {
            case .success:
                log.debug("Successfully registered for Push Notifications")

            case .failure(let error):
                log.error("Error while registering for Push Notifications: \(error.localizedDescription)")
            }
        }
    }

    func application(_ application: Application, didFailToRegisterForRemoteNotificationsWithError error: Error) {
        log.error("Error while registering for Remote Notifications: \(error.localizedDescription)")
    }

#if os(macOS)
    func application(_ application: Application, didReceiveRemoteNotification userInfo: [String : Any]) {
        log.debug("Did receive remote notification: \(userInfo)")
        Application.handleRemoteNotification(userInfo: userInfo)
    }
#else
    func application(_ application: Application, didReceiveRemoteNotification userInfo: [AnyHashable : Any], fetchCompletionHandler completionHandler: @escaping (UIBackgroundFetchResult) -> Void) {
        log.debug("Did receive remote notification: \(userInfo)")
        Application.handleRemoteNotification(userInfo: userInfo)
        completionHandler(.newData)
    }
#endif
}
