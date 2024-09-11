// Playable - 🎧
// This file is part of the Playable project.
// Copyright (c) 2015-2023 Woodbytes, <phranck@mac.com>
//
// Created by: Frank Gregor
// Created at: 29.01.23
//

import SwiftUI

enum NavigationItemGroup: Identifiable {
    var id: UUID { UUID() }

    case podcast([NavigationItem])
    case general([NavigationItem])
}

extension NavigationItemGroup {
    var title: String {
        switch self {
            case .podcast: String(localized: "Podcasts")
            case .general: String(localized: "General")
        }
    }

    var imageName: String {
        switch self {
            case .podcast: "antenna.radiowaves.left.and.right"
            case .general: "checklist.checked"
        }
    }
}

extension NavigationItemGroup: CaseIterable {
    static let allCases: [NavigationItemGroup] = [
        .podcast(NavigationItem.allCasesPodcast),
        .general(NavigationItem.allCasesGeneral)
    ]
}
