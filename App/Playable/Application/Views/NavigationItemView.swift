//
// Playable - 🎧
// This file is part of the Playable project.
// Copyright (c) 2015-2023 Woodbytes, <phranck@mac.com>
//
// Created by: Frank Gregor
// Created at: 15.01.23
//

import PlayableFoundation
import SwiftUI

struct NavigationItemView: View {
    let item: NavigationItem
    let count: Int

    var body: some View {
        HStack {
            Label(item.title, systemSymbol: item.icon)
                .fontDesign(.rounded)
                .padding(.vertical, 4)
                .padding(.horizontal, 8)
                .cornerRadius(5)

            Spacer()

            Text("\(count)")
                .font(.body)
                .padding(.horizontal, 6)
                .padding(.vertical, 2)

        }
    }
}

struct SidebarItemView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationItemView(item: .discover, count: 3)
            .frame(width: 230)
    }
}
