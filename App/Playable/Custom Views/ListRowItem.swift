//
//  ListRow.swift
//  Playable
//
//  Created by Frank Gregor on 26.11.20.
//  Copyright © 2020 Woodbytes. All rights reserved.
//

import SwiftUI

protocol ListRowItemModel: Hashable {
    var name: String { get }
    var description: LocalizedStringKey { get }
    var iconName: String { get }
}

struct ListRowItem<Model: ListRowItemModel>: View {
    @Environment(\.hapticFeedback) var feedback
    
    var model: Model

    var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 8)
                .foregroundColor(.secondarySystemBackground)

            HStack {
                Image(model.iconName)
                    .renderingMode(.template)
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: 42, height: 42, alignment: .center)
                    .padding(.trailing, 8)
                    .foregroundColor(.label)

                VStack(alignment: .leading) {
                    Text(model.name)
                        .font(.system(size: 22, weight: .bold, design: .rounded))
                        .foregroundColor(.label)
                    
                    if let description = model.description {
                        Text(description)
                            .font(.system(size: 16, weight: .regular, design: .rounded))
                            .foregroundColor(.secondaryLabel)
                    }
                }
                
                Spacer()

                Image(systemName: "chevron.right")
                    .foregroundColor(.secondaryLabel)
            }
            .padding(10)
        }
        .padding([.leading, .trailing], 10)
    }
}

// MARK: - Preview

struct ServiceRow_Previews: PreviewProvider {
    static var previews: some View {
        ListRowItem(
            model: StreamingServiceRowItem(type: .radio)
        )
    }
}
