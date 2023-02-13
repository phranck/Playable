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

struct NavigationGroupModel: Equatable, Identifiable {
    let id: Tagged<Self, UUID> = Self.ID(UUID())
    var title: LocalizedStringKey = ""
    var symbol: SFSymbol?
    var isCollapsed = false
    var items: IdentifiedArrayOf<NavigationItemModel> = []
}

// MARK: - NavigationItem

struct NavigationItemModel: Equatable, Identifiable {
    let id: Tagged<Self, UUID> = Self.ID(UUID())
    var title: LocalizedStringKey = ""
    var symbol: SFSymbol?
}
