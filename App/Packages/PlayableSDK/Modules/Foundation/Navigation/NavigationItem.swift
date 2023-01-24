// Playable - 🎧
// This file is part of the Playable project.
// Copyright (c) 2015-2023 Woodbytes, <phranck@mac.com>
//
// Created by: Frank Gregor
// Created at: 14.01.23
//

import SFSafeSymbols
import SwiftUI

public enum NavigationGroups: Int, Identifiable, CaseIterable {
    public var id: Int { rawValue }

    case podcasts = 0
    case radio
    case general
}

public enum NavigationItem: Int, Identifiable, CaseIterable {
    public var id: Int { rawValue }

    case live = 0
    case discover
    case subscribed
    case popular
    case featured
}

public extension NavigationItem {
    var title: String {
        switch self {
        case .live:
            return "Live"
        case .discover:
            return "Discover"
        case .subscribed:
            return "Subscribed"
        case .popular:
            return "Popular"
        case .featured:
            return "Featured"
        }
    }

    var icon: SFSymbol {
        switch self {
        case .live:
            return .antennaRadiowavesLeftAndRight
        case .discover:
            return .waveformAndMagnifyingglass
        case .subscribed:
            return .checklistChecked
        case .popular:
            return .chartLineUptrendXyaxis
        case .featured:
            return .medal
        }
    }

    var shortcut: KeyboardShortcut {
        switch self {
        case .live:
            return KeyboardShortcut("1", modifiers: .command)
        case .discover:
            return KeyboardShortcut("2", modifiers: .command)
        case .subscribed:
            return KeyboardShortcut("3", modifiers: .command)
        case .popular:
            return KeyboardShortcut("4", modifiers: .command)
        case .featured:
            return KeyboardShortcut("5", modifiers: .command)
        }
    }
}

public extension NavigationItem {
    
}
