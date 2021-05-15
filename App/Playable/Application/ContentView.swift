//
//  ContentView.swift
//  Playable (iOS)
//
//  Created by Frank Gregor on 18.11.20.
//

import SwiftUI

struct ContentView: View {
    @State private var selectedTab = TabItemTag.services

    var body: some View {
        TabView(selection: $selectedTab) {
            DevicesTabView()
                .tabItem {
                    Label(LocalizedStringKey("Devices"), systemImage: "hifispeaker.2.fill")
                }
                .tag(TabItemTag.devices)

            ServicesTabView()
                .tabItem {
                    Label(LocalizedStringKey("Services"), systemImage: "music.quarternote.3")
                }
                .tag(TabItemTag.services)

            FavoritesTabView()
                .tabItem {
                    Label(LocalizedStringKey("Favorites"), systemImage: "heart.fill")
                }
                .tag(TabItemTag.favorites)

            SettingsTabView()
                .tabItem {
                    Label(LocalizedStringKey("Settings"), systemImage: "gearshape.fill")
                }
                .tag(TabItemTag.settings)
        }
        .background(.background)
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
            .preferredColorScheme(.dark)
            
    }
}

private enum TabItemTag: Int {
    case devices
    case services
    case favorites
    case settings
}
