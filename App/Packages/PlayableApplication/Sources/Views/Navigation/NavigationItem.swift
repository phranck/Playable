// Playable - 🎧
// This file is part of the Playable project.
// Copyright (c) 2015-2023 Woodbytes, <phranck@mac.com>
//
// Created by: Frank Gregor
// Created at: 29.01.23
//

import SwiftUI

enum NavigationItem: Identifiable, CaseIterable {
    var id: UUID { UUID() }

    // Podcast
    case live
    case discover
    case subscribed
    case popular
    case featured

    // General
    case settings
    case account
}

extension NavigationItem {
    var title: String {
        switch self {
        case .live:       String(localized: "Live")
        case .discover:   String(localized: "Discover")
        case .subscribed: String(localized: "Subscribed")
        case .popular:    String(localized: "Popular")
        case .featured:   String(localized: "Featured")
        case .settings:   String(localized: "Settings")
        case .account:    String(localized: "Account")
        }
    }

    var imageName: String {
        switch self {
        case .live:       "antenna.radiowaves.left.and.right"
        case .discover:   "waveform.badge.magnifyingglass"
        case .subscribed: "checklist.checked"
        case .popular:    "chart.line.uptrend.xyaxis"
        case .featured:   "medal"
        case .settings:   "gearshape"
        case .account:    "person.fill"
        }
    }

    var shortcut: KeyboardShortcut {
        switch self {
        case .live:       KeyboardShortcut("1", modifiers: .command)
        case .discover:   KeyboardShortcut("2", modifiers: .command)
        case .subscribed: KeyboardShortcut("3", modifiers: .command)
        case .popular:    KeyboardShortcut("4", modifiers: .command)
        case .featured:   KeyboardShortcut("5", modifiers: .command)
        case .settings:   KeyboardShortcut("8", modifiers: .command)
        case .account:    KeyboardShortcut("9", modifiers: .command)
        }
    }
}

extension NavigationItem {
    static let allCasesPodcast: [NavigationItem] = [.live, .discover, .subscribed, .popular, .featured]
    static let allCasesGeneral: [NavigationItem] = [.settings, .account]
}
