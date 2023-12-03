// Playable - 🎧
// This file is part of the Playable project.
// Copyright (c) 2015-2023 Woodbytes, <phranck@mac.com>
//
// Created by: Frank Gregor
// Created at: 14.01.23
//

import PlayableFoundation
import PlayableParse
import SDWebImageSwiftUI
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
                CoverImage(channel: channel, imageSize: $imageSize)

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

struct CoverImage: View {
    @State private var isHovered = false
    let channel: Channel
    @Binding var imageSize: CGFloat

    var body: some View {
        WebImage(url: channel.coverartThumbnail200?.url)
            .resizable()
            .frame(width: imageSize, height: imageSize)
            .overlay {
                Color.black
                    .opacity(isHovered ? 0.75 : 0)
                    .overlay {
                        Image(systemName: "play.circle.fill")
                            .symbolRenderingMode(.hierarchical)
                            .font(.system(size: 36))
                            .bold()
                            .foregroundColor(.white)
                            .opacity(isHovered ? 1 : 0)
                    }
                    .animation(.easeInOut(duration: 0.1), value: isHovered)
            }
            .onHover { hover in
                isHovered = hover
            }
    }
}

private extension CoverImage {
    func coverImage(_ image: Image) -> some View {
        image
            .renderingMode(.original)
            .resizable()
    }

    func coverPlaceholderImage() -> some View {
        Image(systemName: "photo.circle.fill")
            .resizable()
            .frame(maxWidth: .infinity, maxHeight: .infinity)
    }
}
