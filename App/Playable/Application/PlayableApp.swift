// Playable - 🎧
// This file is part of the Playable project.
// Copyright (c) 2015-2022 Woodbytes, <phranck@mac.com>
//
// Created by: Frank Gregor
// Created at: 01.12.22
//

import PlayableFoundation
import PlayableParse
import PlayableUI
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
        .defaultSize(width: 960, height: 520)
        .defaultPosition(.center)
        .commands {
            CommandGroup(replacing: .appInfo) {
                Button("About MyGreatApp") {
                    NSApp.orderFrontStandardAboutPanel(
                        options: [
                            NSApplication.AboutPanelOptionKey.credits: NSAttributedString(
                                string: "Never miss a live streaming podcast",
                                attributes: [
                                    .font: NSFont.boldSystemFont(ofSize: NSFont.smallSystemFontSize)
                                ]
                            ),
                            NSApplication.AboutPanelOptionKey(
                                rawValue: "Copyright"
                            ): "© 2022 Woodbytes"
                        ]
                    )
                }
            }
        }
    }
}
