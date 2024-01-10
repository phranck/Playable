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
    @NSApplicationDelegateAdaptor(PlayableAppDelegate.self) var appDelegate

    init() {
        setupLogging()
        Parse.setup()
        Parse.setupParseUser()
    }

    var body: some Scene {
        WindowGroup {
            MainView()
        }
        .windowToolbarStyle(UnifiedWindowToolbarStyle())
        .windowStyle(TitleBarWindowStyle())
        .defaultSize(width: 960, height: 520)
        .defaultPosition(.center)
        .commands {
            CommandGroup(replacing: .appInfo) {
                Button(String(localized: "About \(NSApplication.appName)")) {
                    NSApp.orderFrontStandardAboutPanel(
                        options: [
                            NSApplication.AboutPanelOptionKey.credits: credits,
                            NSApplication.AboutPanelOptionKey(rawValue: "Copyright"): "© 2022 Woodbytes"
                        ]
                    )
                }
            }
        }
    }
}

// MARK: - Private Helper

private extension PlayableApp {
    var credits: NSAttributedString {
        NSAttributedString(
            string: String(localized: "Never miss a live streaming podcast\n"),
            attributes: [.font: NSFont.boldSystemFont(ofSize: NSFont.smallSystemFontSize)]
        )
    }
}
