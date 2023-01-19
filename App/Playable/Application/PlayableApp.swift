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
#if os(macOS)
    @NSApplicationDelegateAdaptor(PlayableAppDelegate.self) var appDelegate
#else
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
        .defaultSize(width: 960, height: 520)
        .defaultPosition(.center)
        .commands {
            CommandGroup(replacing: .appInfo) {
                Button("About MyGreatApp") {
                    NSApp.orderFrontStandardAboutPanel(
                        options: [
                            Application.AboutPanelOptionKey.credits: NSAttributedString(
                                string: "Never miss a live streaming podcast",
                                attributes: [
                                    .font: NSFont.boldSystemFont(ofSize: NSFont.smallSystemFontSize)
                                ]
                            ),
                            Application.AboutPanelOptionKey(
                                rawValue: "Copyright"
                            ): "© 2022 Woodbytes"
                        ]
                    )
                }
            }
        }
#endif
    }
}
