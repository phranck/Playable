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


public struct NavigationItemGroup: Identifiable, Hashable {
    public let id = UUID().uuidString

    public let header: String?
    public let items: [NavigationItem]
    public let isCollapsable: Bool
}

public struct NavigationItem: Identifiable, Hashable {
    public let id = UUID().uuidString

    public let title: String
    public let image: Image
    public let view: AnyView
}

extension NavigationItem: Equatable {
    public static func == (lhs: NavigationItem, rhs: NavigationItem) -> Bool {
        lhs.id == rhs.id
    }

    public func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
}




public struct MainView: View {
#if os(iOS)
    @Environment(\.horizontalSizeClass) var horizontalSizeClass
#endif
    @State private var searchText = ""
    @State private var selectedSidebarItem: SidebarItem = .all
    @State private var sidebarVisibility: NavigationSplitViewVisibility = .automatic
    @StateObject var channelService = ChannelService()

    public init() {}

    public var body: some View {
#if os(iOS)
        if horizontalSizeClass == .compact {
            IOSCompactNavigationView(selectedSidebarItem: $selectedSidebarItem)
        } else {
            IOSNavigationView(
                selectedSidebarItem: $selectedSidebarItem,
                sidebarVisibility: $sidebarVisibility,
                channelService: channelService,
                searchText: $searchText
            )
        }
#else
        MacOSNavigationView(
            selectedSidebarItem: $selectedSidebarItem,
            sidebarVisibility: $sidebarVisibility,
            channelService: channelService,
            searchText: $searchText
        )
#endif

    }
}

#if os(macOS)
public struct MacOSNavigationView: View {
    @Binding var selectedSidebarItem: SidebarItem
    @Binding var sidebarVisibility: NavigationSplitViewVisibility
    @ObservedObject var channelService: ChannelService
    @Binding var searchText: String

    public var body: some View {
        NavigationSplitView(columnVisibility: $sidebarVisibility) {
            List(SidebarItem.allCases, selection: $selectedSidebarItem) { item in
                NavigationLink(value: item) {
                    NavigationItemView(item: item, count: 0)
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
#endif

#if os(iOS)
public struct IOSCompactNavigationView: View {
    @Binding var selectedSidebarItem: SidebarItem

    public var body: some View {
        TabView(selection: $selectedSidebarItem) {
            Text("Tab 1")
                .tabItem {
                    Label("Tab1", systemSymbol: .waveform)
                }
            Text("Tab 2")
                .tabItem {
                    Label("Tab2", systemSymbol: .heartFill)
                }
            Text("Tab 3")
                .badge(5)
                .tabItem {
                    Label("Tab3", systemSymbol: .starCircleFill)
                }
            Text("Tab 4")
                .tabItem {
                    Label("Tab4", systemSymbol: .gearshapeFill)
                }
        }
    }
}

struct IOSNavigationView: View {
    @Binding var selectedSidebarItem: SidebarItem
    @Binding var sidebarVisibility: NavigationSplitViewVisibility
    @ObservedObject var channelService: ChannelService
    @Binding var searchText: String

    public var body: some View {
        NavigationSplitView(columnVisibility: $sidebarVisibility) {
            List {
                ForEach(SidebarItem.allCases) { item in
                    NavigationLink(value: item) {
                        NavigationItemView(item: item, count: 0)
                    }
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
#endif




