//
//  PlayableApp.swift
//  Shared
//
//  Created by Frank Gregor on 18.11.20.
//

import SwiftUI
import LinkPlay

@main
struct Playable: App {
    @Environment(\.scenePhase) var scenePhase
    
    let linkPlay = LinkPlay()

    init() {
        setupAppearance()
        setupLogging()

        linkPlay.startDiscover()
    }
    
    var body: some Scene {
        WindowGroup {
            MainView()
                .edgesIgnoringSafeArea(.all)
        }
        .onChange(of: scenePhase) { phase in
            switch phase {
                case .active:
                    log.debug("App phase: active")
                case .background:
                    log.debug("App phase: background")
                case .inactive:
                    log.debug("App phase: inactive")
                @unknown default:
                    log.debug("App phase: unknown default")
            }
        }
    }
}
