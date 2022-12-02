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

public typealias PodliveUserAuthData = [String: [String: String]?]
public typealias PodliveChannels = [String]

public struct PlayableParseUser: ParseUser {
    public var objectId: String?
    public var createdAt: Date?
    public var updatedAt: Date?
    public var ACL: ParseACL?

    // ParseUser
    public var username: String?
    public var email: String?
    public var emailVerified: Bool?
    public var password: String?
    public var authData: PodliveUserAuthData?

    public var channels: PodliveChannels?
    public var originalData: Data?

    public init() {}
}

extension PlayableParseUser {
    enum CodingKeys: String, CodingKey {
        case objectId
        case createdAt
        case updatedAt
        case ACL
        case username
        case email
        case password
        case authData
        case channels
    }
}

extension PlayableParseUser {
    public static var isAnonymous: Bool {
        return PlayableParseUser.current?.email == nil
    }
}
