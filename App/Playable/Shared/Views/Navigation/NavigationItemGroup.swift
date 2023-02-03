// Playable - 🎧
// This file is part of the Playable project.
// Copyright (c) 2015-2023 Woodbytes, <phranck@mac.com>
//
// Created by: Frank Gregor
// Created at: 29.01.23
//

import SFSafeSymbols
import SwiftUI

enum NavigationItemGroup: Identifiable {
    var id: UUID {
        UUID()
    }

    case podcast([NavigationItem])
    case radio([NavigationItem])
    case general([NavigationItem])
}

extension NavigationItemGroup {
    var title: String {
        switch self {
            case .podcast:
                return String(localized: "Podcasts")
            case .radio:
                return String(localized: "Radio")
            case .general:
                return String(localized: "General")
        }
    }

    var icon: SFSymbol {
        switch self {
            case .podcast:
                return .antennaRadiowavesLeftAndRight
            case .radio:
                return .waveformAndMagnifyingglass
            case .general:
                return .checklistChecked
        }
    }
}

extension NavigationItemGroup: CaseIterable {
    static let allCases: [NavigationItemGroup] = [
        .podcast(NavigationItem.allCasesPodcast),
        .radio(NavigationItem.allCasesRadio),
        .general(NavigationItem.allCasesGeneral)
    ]
}
