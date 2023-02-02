//
// Playable - 🎧
// This file is part of the Playable project.
// Copyright (c) 2015-2022 Woodbytes, <phranck@mac.com>
//
// Created by: Frank Gregor
// Created at: 18.12.22
//

import Foundation

public enum ChannelState: String, Codable {
    case `break`
    case invalid
    case live
    case offline
    case online
    case postshow
    case preshow
    case test
}

public extension ChannelState {
    var localizedDescription: String {
        let bundle = Bundle.module

        switch self {
        case .live:
            return String(localized: "Live", bundle: bundle, comment: "channel state live")
        case .online:
            return String(localized: "Online", bundle: bundle, comment: "channel state online")
        case .preshow:
            return String(localized: "Preshow", bundle: bundle, comment: "channel state preshow")
        case .postshow:
            return String(localized: "Postshow", bundle: bundle, comment: "channel state postshow")
        case .`break`:
            return String(localized: "Break", bundle: bundle, comment: "channel state break")
        case .test:
            return String(localized: "Test", bundle: bundle, comment: "channel state test")
        case .invalid:
            return String(localized: "Invalid", bundle: bundle, comment: "channel state invalid")
        case .offline:
            return String(localized: "Offline", bundle: bundle, comment: "channel state offline")
        }
    }
}
