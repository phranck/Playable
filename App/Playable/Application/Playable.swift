//
//  PlayableApp.swift
//  Shared
//
//  Created by Frank Gregor on 18.11.20.
//

import SwiftUI
import RadioBrowser
import LinkPlay
import SwiftyBeaver
let log = SwiftyBeaver.self

@main
struct Playable: App {
    @Environment(\.scenePhase) var scenePhase
    
    let linkPlay = LinkPlay()
    let radioBrowser = RadioBrowser(agent: "Playable", version: RadioBrowser.version)

    init() {
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

        linkPlay.startDiscover()
    }
    
    var body: some Scene {
        WindowGroup {
            ContentView()
                .preferredColorScheme(.dark)
                .background(.background)
                .accentColor(.accent)
                .foregroundColor(.onBackground)
                .navigationBarColor(.primary)
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
