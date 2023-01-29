// Playable - 🎧
// This file is part of the Playable project.
// Copyright (c) 2015-2023 Woodbytes, <phranck@mac.com>
//
// Created by: Frank Gregor
// Created at: 27.01.23
//

import IdentifiedCollections
import SFSafeSymbols
import SwiftUI
import Tagged

// MARK: - NavigationGroup

struct NavigationGroup: Equatable, Identifiable {
    let id: Tagged<Self, UUID> = Self.ID(UUID())
    var title: LocalizedStringKey = ""
    var symbol: SFSymbol?
    var isCollapsed = false
    var items: IdentifiedArrayOf<NavigationItem> = []
}

// MARK: - NavigationItem

struct NavigationItem: Equatable, Identifiable {
    let id: Tagged<Self, UUID> = Self.ID(UUID())
    var title: LocalizedStringKey = ""
    var symbol: SFSymbol?
}
