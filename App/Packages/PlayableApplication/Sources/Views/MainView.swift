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
    @State private var searchText = ""
    @State private var sidebarVisibility: NavigationSplitViewVisibility = .automatic
    @StateObject var channelService = ChannelService()

    public init() {}

    public var body: some View {
        SidebarNavigationView()
            .environmentObject(channelService)
    }
}
