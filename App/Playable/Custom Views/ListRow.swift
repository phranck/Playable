//
//  ListRow.swift
//  Playable
//
//  Created by Frank Gregor on 26.11.20.
//  Copyright © 2020 Woodbytes. All rights reserved.
//

import SwiftUI

protocol ListRowItem: Hashable {
    var name: String { get }
    var description: LocalizedStringKey { get }
    var iconName: String { get }
    var tintColor: Color { get set }
}

struct ListRow<Model: ListRowItem>: View {
    var model: Model
    var hasAccessoryView: Bool = true

    var body: some View {
        HStack {
            HStack {
                HStack {
                    Image(model.iconName)
                        .renderingMode(.template)
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(width: 48, height: 48, alignment: .center)
                        .padding(.trailing, 8)

                    VStack(alignment: .leading) {
                        Text(model.name)
                            .font(.system(size: 21, weight: .bold, design: .rounded))
                        
                        if let description = model.description {
                            Text(description)
                                .font(.system(size: 15, weight: .regular, design: .rounded))
                                .foregroundColor(.secondary)
                        }
                    }
                    Spacer()
                }
                .padding()
            }
            .foregroundColor(.primary)
            .background(Color.secondarySystemBackground)
            .cornerRadius(13, antialiased: true)
            .shadow(color: Color.systemGray.opacity(0.35), radius: 0, x: 0, y: -1)
            .shadow(color: Color.black.opacity(0.6), radius: 0, x: 0, y: 1)

            if hasAccessoryView {
                VStack {
                    Image(systemName: "chevron.forward")
                        .font(.system(size: 23, weight: .semibold, design: .rounded))
                        .foregroundColor(.secondary)
                }
            }
        }
        .padding(EdgeInsets(top: 3, leading: 0, bottom: 3, trailing: 0))
    }
}

// MARK: - Preview

struct ServiceRow_Previews: PreviewProvider {
    static var previews: some View {
        ListRow(
            model: StreamingServiceRowItem(type: .radio)
        )
        .preferredColorScheme(.dark)
    }
}
