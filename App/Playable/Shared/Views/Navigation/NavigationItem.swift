// Playable - 🎧
// This file is part of the Playable project.
// Copyright (c) 2015-2023 Woodbytes, <phranck@mac.com>
//
// Created by: Frank Gregor
// Created at: 29.01.23
//

import SFSafeSymbols
import SwiftUI

enum NavigationItem: Identifiable {
    var id: UUID {
        UUID()
    }

    // Podcast
    case live
    case discover
    case subscribed
    case popular
    case featured

    // Radio
    case local
    case favorites

    // General
    case settings
    case account
}

extension NavigationItem {
    var title: String {
        switch self {
            case .live:
                return String(localized: "Live")
            case .discover:
                return String(localized: "Discover")
            case .subscribed:
                return String(localized: "Subscribed")
            case .popular:
                return String(localized: "Popular")
            case .featured:
                return String(localized: "Featured")
            case .local:
                return String(localized: "Local Stations")
            case .favorites:
                return String(localized: "Favorites")
            case .settings:
                return String(localized: "Settings")
            case .account:
                return String(localized: "Account")
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
            case .local:
                return .antennaRadiowavesLeftAndRight
            case .favorites:
                return .checklistChecked
            case .settings:
                return .gearshape
            case .account:
                return .personFill
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
            case .local:
                return KeyboardShortcut("6", modifiers: .command)
            case .favorites:
                return KeyboardShortcut("7", modifiers: .command)
            case .settings:
                return KeyboardShortcut("8", modifiers: .command)
            case .account:
                return KeyboardShortcut("9", modifiers: .command)
        }
    }
}

extension NavigationItem {
    static let allCasesPodcast: [NavigationItem] = [.live, .discover, .subscribed, .popular, .featured]
    static let allCasesRadio: [NavigationItem] = [.local, .favorites]
    static let allCasesGeneral: [NavigationItem] = [.settings, .account]
}
