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

struct SidebarItemView: View {
    let item: SidebarItem
    let count: Int

    var body: some View {
        HStack(spacing: 8) {
            Image(systemSymbol: item.icon)
                .symbolRenderingMode(.hierarchical)
                .font(.title)

            Text(item.title)
                .font(.title3)

            Spacer()

//            Text("\(count)")
//                .font(.caption)
//                .background(Color.textBackground)
//                .padding(6)
//                .cornerRadius(2)
        }
        .fontDesign(.rounded)
        .padding(.vertical, 4)
        .padding(.horizontal, 8)
        .cornerRadius(5)
    }
}

struct SidebarItemView_Previews: PreviewProvider {
    static var previews: some View {
        SidebarItemView(item: .all, count: 3)
            .frame(width: 230)
    }
}
