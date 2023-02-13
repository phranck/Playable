//
// Playable - 🎧
// This file is part of the Playable project.
// Copyright (c) 2015-2022 Woodbytes, <phranck@mac.com>
//
// Created by: Frank Gregor
// Created at: 18.12.22
//

import Foundation
import ParseSwift

public extension Channel {
    static var allChannels: Query<Channel> {
        Channel
            .query(CodingKeys.isEnabled.rawValue == true)
            .order([
                .descending(CodingKeys.followerCount.rawValue),
                .ascending(CodingKeys.name.rawValue)
            ])
            .limit(.max)
    }

    static var liveChannels: Query<Channel> {
        Channel.query(
            CodingKeys.isEnabled.rawValue == true,
            CodingKeys.state.rawValue == ChannelState.live.rawValue
        )
        .order([
            .descending(CodingKeys.followerCount.rawValue),
            .ascending(CodingKeys.name.rawValue)
        ])
        .limit(.max)
    }
}
