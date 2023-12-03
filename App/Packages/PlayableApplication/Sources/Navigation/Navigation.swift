// Playable - 🎧
// This file is part of the Playable project.
// Copyright (c) 2015-2023 Woodbytes, <phranck@mac.com>
//
// Created by: Frank Gregor
// Created at: 27.01.23
//

import SwiftUI

// MARK: - NavigationGroup

struct NavigationGroupModel: Equatable, Identifiable {
    let id = UUID()
    var title: LocalizedStringKey = ""
    var systemIconName: String?
    var isCollapsed = false
    var items: [NavigationItemModel] = []
}

// MARK: - NavigationItem

struct NavigationItemModel: Equatable, Identifiable {
    let id = UUID()
    var title: LocalizedStringKey = ""
    var systemIconName: String?
}
