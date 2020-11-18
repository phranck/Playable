//
//  PlayableApp.swift
//  Shared
//
//  Created by Frank Gregor on 18.11.20.
//

import SwiftUI

@main
struct Playable: App {
    @Environment(\.scenePhase) var scenePhase
    let browser = DeviceBrowser()
    
    init() {
        setupLogging()
        setupAppearance()
        
        browser.start()
    }
    
    var body: some Scene {
        WindowGroup {
            ContentView()
                .preferredColorScheme(.dark)
                .background(Color.gray)
                .accentColor(.label)
                .foregroundColor(.secondaryLabel)
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
