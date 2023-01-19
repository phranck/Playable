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

public struct Channel: ParseObject, Identifiable {
    public var id: String {
        objectId ?? ""
    }

    public var ACL: ParseSwift.ParseACL?
    public var createdAt: Date?
    public var objectId: String?
    public var originalData: Data?
    public var updatedAt: Date?

//    public var categories: [ChannelCategory]?
    public var chatUrlString: String?
    public var creator: String?
    public var description: String?
    public var followerCount: Int = 0
    public var isEnabled: Bool?
    public var lastActivityAt: Date?
    public var listenerCount: Int?
    public var name: String = ""
    public var rssFeedUrlString: String?
    public var state: ChannelState?
    public var streamUrlString: String?
    public var streamingBackend: String?
    public var twitterUsernameString: String?
    public var websiteUrlString: String?

    public var coverartThumbnail200: Coverart?
    public var coverartThumbnail800: Coverart?
    public var coverartThumbnail1400: Coverart?

    public init() {}
}

public extension Channel {
    enum CodingKeys: String, CodingKey, CaseIterable {
        case createdAt
        case objectId
        case updatedAt

        case chatUrlString
        case coverartThumbnail200
        case coverartThumbnail800
        case coverartThumbnail1400
        case creator
        case description
        case followerCount
        case isEnabled
        case lastActivityAt
        case listenerCount
        case name
        case rssFeedUrlString
        case state
        case streamUrlString
        case streamingBackend
        case twitterUsernameString
        case websiteUrlString
    }
}
