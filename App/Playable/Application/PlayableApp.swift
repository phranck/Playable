// Playable - 🎧
// This file is part of the Playable project.
// Copyright (c) 2015-2022 Woodbytes, <phranck@mac.com>
//
// Created by: Frank Gregor
// Created at: 01.12.22
//

import PlayableApplication
import PlayableFoundation
import PlayableParse
import SwiftUI

@main
struct PlayableApp: App {
#if os(macOS)
    @NSApplicationDelegateAdaptor(PlayableAppDelegate.self) var appDelegate
#elseif os(iOS)
    @UIApplicationDelegateAdaptor(PlayableAppDelegate.self) var appDelegate
#endif

    init() {
        setupLogging()
        Parse.setup()
        Parse.setupParseUser()
    }

    var body: some Scene {
        WindowGroup {
            MainView()
        }
#if os(macOS)
        .windowToolbarStyle(UnifiedWindowToolbarStyle())
        .windowStyle(TitleBarWindowStyle())
        .defaultSize(width: 960, height: 520)
        .defaultPosition(.center)
        .commands {
            CommandGroup(replacing: .appInfo) {
                Button(String(localized: "About \(PlatformApplication.appName)")) {
                    NSApp.orderFrontStandardAboutPanel(
                        options: [
                            PlatformApplication.AboutPanelOptionKey.credits: credits,
                            PlatformApplication.AboutPanelOptionKey(rawValue: "Copyright"): "© 2022 Woodbytes"]
                    )
                }
            }
        }
#endif
    }
}

// MARK: - Private Helper

#if os(macOS)
private extension PlayableApp {
    var credits: NSAttributedString {
        return NSAttributedString(
            string: String(localized: "Never miss a live streaming podcast\n"),
            attributes: [.font: NSFont.boldSystemFont(ofSize: NSFont.smallSystemFontSize)]
        )
    }
}
#endif
