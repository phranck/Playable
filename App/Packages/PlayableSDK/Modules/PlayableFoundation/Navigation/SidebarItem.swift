// Playable - 🎧
// This file is part of the Playable project.
// Copyright (c) 2015-2023 Woodbytes, <phranck@mac.com>
//
// Created by: Frank Gregor
// Created at: 14.01.23
//

import SFSafeSymbols
import SwiftUI

public enum SidebarItem: Int, Identifiable, CaseIterable {
    public var id: Int { rawValue }

    case live = 0
    case all
    case favorites
    case popular
    case featured
}

public extension SidebarItem {
    var title: LocalizedStringKey {
        switch self {
        case .live:
            return LocalizedStringKey("Live")
        case .all:
            return LocalizedStringKey("All")
        case .favorites:
            return LocalizedStringKey("Favorites")
        case .popular:
            return LocalizedStringKey("Popular")
        case .featured:
            return LocalizedStringKey("Featured")
        }
    }

    var icon: SFSymbol {
        switch self {
        case .live:
            return .antennaRadiowavesLeftAndRight
        case .all:
            return .waveform
        case .favorites:
            return .starCircleFill
        case .popular:
            return .chartLineUptrendXyaxisCircleFill
        case .featured:
            return .handThumbsupFill
        }
    }

    var shortcut: KeyboardShortcut {
        switch self {
        case .live:
            return KeyboardShortcut("1", modifiers: .command)
        case .all:
            return KeyboardShortcut("2", modifiers: .command)
        case .favorites:
            return KeyboardShortcut("3", modifiers: .command)
        case .popular:
            return KeyboardShortcut("4", modifiers: .command)
        case .featured:
            return KeyboardShortcut("5", modifiers: .command)
        }
    }
}
