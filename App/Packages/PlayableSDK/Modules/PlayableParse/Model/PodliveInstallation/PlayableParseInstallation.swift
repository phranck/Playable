//
// Playable - 🎧
// This file is part of the Playable project.
// Copyright (c) 2015-2022 Woodbytes, <phranck@mac.com>
//
// Created by: Frank Gregor
// Created at: 01.12.22
//

import Foundation
import ParseSwift

public struct PlayableParseInstallation: ParseInstallation {
    public var originalData: Data?

    // ParseObject
    public var objectId: String?
    public var createdAt: Date?
    public var updatedAt: Date?
    public var ACL: ParseACL?
    public var score: Double?

    // ParseInstallation
    public var installationId: String?
    public var deviceType: String?
    public var deviceToken: String?
    public var badge: Int?
    public var timeZone: String?
    public var channels: PodliveChannels?
    public var appName: String?
    public var appIdentifier: String?
    public var appVersion: String?
    public var parseVersion: String?
    public var localeIdentifier: String?

    public var user: PlayableParseUser?

    public init() {}
}

public extension PlayableParseInstallation {
    enum CodingKeys: String, CodingKey {
        case objectId
        case createdAt
        case updatedAt
        case ACL
        case installationId
        case deviceType
        case deviceToken
        case badge
        case timeZone
        case channels
        case appName
        case appIdentifier
        case appVersion
        case parseVersion
        case localeIdentifier
        case user
    }
}
