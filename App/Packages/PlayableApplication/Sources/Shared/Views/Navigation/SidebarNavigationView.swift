// Playable - 🎧
// This file is part of the Playable project.
// Copyright (c) 2015-2023 Woodbytes, <phranck@mac.com>
//
// Created by: Frank Gregor
// Created at: 29.01.23
//

import SFSafeSymbols
import SwiftUI

struct SidebarNavigationView: View {
    @State private var selection: NavigationItem = .discover

    var body: some View {
        NavigationSplitView {
            List(NavigationItemGroup.allCases, selection: $selection) { group in
                Section(group.title.uppercased()) {
                    switch group {
                        case .podcast(let items), .radio(let items), .general(let items):
                            ForEach(items, id: \.self) { item in
                                NavigationLink(value: item) {
                                    Label(item.title, systemSymbol: item.icon)
                                }
                                .keyboardShortcut(item.shortcut)
                            }
                    }
                }
            }
            .listStyle(SidebarListStyle())
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
                case .local:
                    EmptyView()
                case .favorites:
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
