//
//  MainView.swift
//  Playable (iOS)
//
//  Created by Frank Gregor on 18.11.20.
//

import SwiftUI

struct MainView: View {
    @State private var selectedTab = TappableViewItem.services

    var body: some View {
        TabView(selection: $selectedTab) {
            PlayingTabView()
                .tabItem {
                    Label(
                        TappableViewItem.playing.titleKey,
                        systemImage: TappableViewItem.playing.systemImageName
                    )
                }
                .tag(TappableViewItem.playing)
                .foregroundColor(.label)

            FavoritesTabView()
                .tabItem {
                    Label(
                        TappableViewItem.favorites.titleKey,
                        systemImage: TappableViewItem.favorites.systemImageName
                    )
                }
                .tag(TappableViewItem.favorites)

            ServicesTabView()
                .tabItem {
                    Label(
                        TappableViewItem.services.titleKey,
                        systemImage: TappableViewItem.services.systemImageName
                    )
                }
                .tag(TappableViewItem.services)

            SettingsTabView()
                .tabItem {
                    Label(
                        TappableViewItem.settings.titleKey,
                        systemImage: TappableViewItem.settings.systemImageName
                    )
                }
                .tag(TappableViewItem.settings)
        }
    }
}

struct MainView_Previews: PreviewProvider {
    static var previews: some View {
        MainView()
    }
}
