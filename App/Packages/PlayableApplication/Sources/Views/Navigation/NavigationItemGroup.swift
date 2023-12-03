// Playable - 🎧
// This file is part of the Playable project.
// Copyright (c) 2015-2023 Woodbytes, <phranck@mac.com>
//
// Created by: Frank Gregor
// Created at: 29.01.23
//

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

    var icon: String {
        switch self {
            case .podcast:
                return "antenna.radiowaves.left.and.right"
            case .radio:
                return "waveform.badge.magnifyingglass"
            case .general:
                return "checklist.checked"
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
