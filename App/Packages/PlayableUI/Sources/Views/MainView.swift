// Playable - 🎧
// This file is part of the Playable project.
// Copyright (c) 2015-2023 Woodbytes, <phranck@mac.com>
//
// Created by: Frank Gregor
// Created at: 01.12.22
//

import PlayableFoundation
import PlayableParse
import SwiftUI

public struct MainView: View {
    @State private var selectedSidebarItem: SidebarItem = .all
    @State private var sidebarVisibility: NavigationSplitViewVisibility = .automatic
    @State private var searchText = ""

    @StateObject var channelService = ChannelService()

    public init() {}

    public var body: some View {
        NavigationSplitView(columnVisibility: $sidebarVisibility) {
            List(SidebarItem.allCases, selection: $selectedSidebarItem) { item in
                NavigationLink(value: item) {
                    SidebarItemView(item: item, count: 0)
                }
            }
            .listStyle(SidebarListStyle())
            .navigationSplitViewColumnWidth(min: 200, ideal: 230, max: 280)
        } detail: {
            switch selectedSidebarItem {
            case .live:
                Text(selectedSidebarItem.title)

            case .all:
                ChannelGridView()
                    .navigationSplitViewColumnWidth(min: 790, ideal: 790)

            case .favorites:
                Text(selectedSidebarItem.title)

            case .popular:
                Text(selectedSidebarItem.title)

            case .featured:
                Text(selectedSidebarItem.title)
            }
        }
        .environmentObject(channelService)
        .navigationSplitViewStyle(.balanced)
        .searchable(text: $searchText)
        .toolbar {
            ToolbarItem(placement: .secondaryAction) {
                Text("PlayerView Placeholder")
                    .frame(height: 164)
            }
        }
    }
}
