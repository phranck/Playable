// Playable - 🎧
// This file is part of the Playable project.
// Copyright (c) 2015-2023 Woodbytes, <phranck@mac.com>
//
// Created by: Frank Gregor
// Created at: 15.01.23
//

import PlayableParse
import SwiftUI

public struct ChannelGridView: View {
    @EnvironmentObject private var channelService: ChannelService
    @State private var itemSize: Double = 320
    @State private var itemSpacing: Double = 20
    @State private var itemImageSize: CGFloat = 96

    public init() {}

    public var body: some View {
        ScrollView {
            LazyVGrid(columns: [GridItem(.adaptive(minimum: itemSize), alignment: .topLeading)], spacing: itemSpacing) {
                ForEach(channelService.channels) { channel in
                    ChannelGridItem(channel: channel, imageSize: $itemImageSize, itemSize: $itemSize)
                }
            }
            .padding()
        }
    }
}
