// Playable - 🎧
// This file is part of the Playable project.
// Copyright (c) 2015-2023 Woodbytes, <phranck@mac.com>
//
// Created by: Frank Gregor
// Created at: 29.01.23
//

import SwiftUI

import NeoKit

struct SidebarNavigationView: View {
    @State private var selection: NavigationItem = .discover

    var body: some View {
        NavigationSplitView {
            List(NavigationItemGroup.allCases, selection: $selection) { group in
                Section(group.title.uppercased()) {
                    switch group {
                    case .podcast(let items), .general(let items):
                        ForEach(items, id: \.self) { item in
                            NavigationLink(value: item) {
                                Label(item.title, systemImage: item.imageName)
                            }
                            .keyboardShortcut(item.shortcut)
                        }
                    }
                }
            }
            .background {
                Color.neoBackground
            }
            .listStyle(SidebarListStyle())
            .navigationSplitViewColumnWidth(min: 160, ideal: 240, max: 320)
        } detail: {
            switch selection {
            case .live:
                EmptyView()
            case .discover:
                ChannelGridView()
            case .subscribed:
                EmptyView()
            case .popular:
                EmptyView()
            case .featured:
                EmptyView()
            case .settings:
                EmptyView()
            case .account:
                EmptyView()
            }
        }
        .navigationSplitViewStyle(.balanced)
    }
}
