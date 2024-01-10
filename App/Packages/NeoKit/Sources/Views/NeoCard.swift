// Playable - 🎧
// This file is part of the Playable project.
// Copyright (c) 2015-2023 Woodbytes, <phranck@mac.com>
//
// Created by: Frank Gregor
// Created at: 08.12.23
//

import SwiftUI

struct NeoCard<Content: View>: View {
    let title: String
    let subTitle: String?
    let content: () -> Content

    init(title: String, subTitle: String?, content: @escaping () -> Content) {
        self.title = title
        self.subTitle = subTitle
        self.content = content
    }

    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("Abort")
                .padding()
        }
        .frame(minWidth: 100)
        .background(Color.neoBackground)
        .clipShape(RoundedRectangle(cornerRadius: 12))
        .shadow(color: .gray.opacity(0.3), radius: 1, x: -1, y: -1)
        .shadow(color: .neoDarkestGrey, radius: 1, x: 1, y: 1)
    }
}

#Preview {
    Group {
        NeoCard(title: "Card", subTitle: "This is a card example") {
            Text("Das ist der Content.")
        }
    }
    .padding(40)
}
