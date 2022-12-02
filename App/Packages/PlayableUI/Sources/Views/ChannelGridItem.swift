// Playable - 🎧
// This file is part of the Playable project.
// Copyright (c) 2015-2023 Woodbytes, <phranck@mac.com>
//
// Created by: Frank Gregor
// Created at: 14.01.23
//

import CachedAsyncImage
import PlayableFoundation
import PlayableParse
import SFSafeSymbols
import SwiftUI
import SystemColors

public struct ChannelGridItem: View {
    let channel: Channel
    @Binding var imageSize: CGFloat
    @Binding var itemSize: Double

    public init(channel: Channel, imageSize: Binding<CGFloat>, itemSize: Binding<Double>) {
        self.channel = channel
        self._imageSize = imageSize
        self._itemSize = itemSize
    }

    public var body: some View {
        VStack {
            HStack(alignment: .top) {
                // Cover
                CachedAsyncImage(url: channel.coverartThumbnail200?.url, urlCache: .imageCache) { image in
                    image
                        .renderingMode(.original)
                        .resizable()
                } placeholder: {
                    Image(systemSymbol: .photoCircleFill)
                        .resizable()
                        .frame(maxWidth: .infinity, maxHeight: .infinity)
                }
                .frame(width: imageSize, height: imageSize)

                // Title & Description
                VStack(alignment: .leading, spacing: 8) {
                    Text(channel.name)
                        .font(.title3)
                        .bold()

                    if let description = channel.description {
                        Text(description)
                            .font(.callout)
                            .lineLimit(3)
                            .help(description)
                    }
                }
                .padding(10)
                Spacer(minLength: 1)

                VStack {
                    Spacer()
                    Image(systemSymbol: .playCircleFill)
                        .font(.system(size: 36))
                        .bold()
                    Spacer()
                }
                .padding()
            }
            .frame(maxWidth: .infinity)
        }
        .frame(maxHeight: imageSize)
        .symbolRenderingMode(.hierarchical)
        .background(.regularMaterial)
        .fontDesign(.rounded)
        .cornerRadius(16)
        .shadow(radius: 8, y: 5)
    }
}

// MARK: - Private Helper

private extension URLCache {
    static let imageCache = URLCache(
        memoryCapacity: 50_000_000,
        diskCapacity: 1_000_000_000
    )
}

// MARK: - Preview

struct ChannelGridItem_Previews: PreviewProvider {
    @State private static var itemImageSize: CGFloat = 96
    @State private static var itemSize: Double = 340

    static var channel = Channel(
        name: "Test Podcast",
        description: "Testet Dinge und programmiert Software. Testet Dinge und programmiert Software.",
        followerCount: 42,
        coverUrlString: "https://picsum.photos/800"
    )

    static var previews: some View {
        VStack {
            ChannelGridItem(channel: channel, imageSize: $itemImageSize, itemSize: $itemSize)
        }
        .padding(36)
        .background(Color.systemTeal)
    }
}

private extension Channel {
    init(
        name: String,
        description: String,
        followerCount: Int,
        coverUrlString: String,
        websiteUrl: String? = nil,
        twitterName: String? = nil,
        state: ChannelState = .offline
    ) {
        self.init()

        // swiftlint:disable force_try
        let cover = try! JSONDecoder().decode(
            Coverart.self,
            from: Data("{\"name\": \"LoremPicture\", \"url\": \"\(coverUrlString)\"}".utf8)
        )

        self.name = name
        self.description = description
        self.followerCount = followerCount
        self.coverartThumbnail200 = cover
        self.coverartThumbnail800 = cover
        self.coverartThumbnail1400 = cover
    }
}
