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
            return NSLocalizedString("channel state live", bundle: bundle, value: "Live", comment: "channel state live")
        case .online:
            return NSLocalizedString("channel state online", bundle: bundle, value: "Online", comment: "channel state online")
        case .preshow:
            return NSLocalizedString("channel state preshow", bundle: bundle, value: "Preshow", comment: "channel state preshow")
        case .postshow:
            return NSLocalizedString("channel state postshow", bundle: bundle, value: "Postshow", comment: "channel state postshow")
        case .`break`:
            return NSLocalizedString("channel state break", bundle: bundle, value: "Break", comment: "channel state break")
        case .test:
            return NSLocalizedString("channel state test", bundle: bundle, value: "Test", comment: "channel state test")
        case .invalid:
            return NSLocalizedString("channel state invalid", bundle: bundle, value: "Invalid", comment: "channel state invalid")
        case .offline:
            return NSLocalizedString("channel state offline", bundle: bundle, value: "Offline", comment: "channel state offline")
        }
    }
}
