//
//  PlayableApp.swift
//  Shared
//
//  Created by Frank Gregor on 18.11.20.
//

import SwiftUI
import RadioBrowser

@main
struct Playable: App {
    @Environment(\.scenePhase) var scenePhase
    
    let deviceBrowser: DeviceBrowser!
    let radioBrowser = RadioBrowser(agent: "Playable", version: RadioBrowser.version)

    init() {
        deviceBrowser = DeviceBrowser()
        deviceBrowser.start()

        setupLogging()
        setupAppearance()
        
        let realm = RealmManager.sharedInstance
        realm.start()

        radioBrowser.stationsForCountryCode("de") { result in
            do {
                let stations = try result.get()
                realm.addOrUpdate(stations)
            }
            catch {
                log.error(error.localizedDescription)
            }
        }
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
