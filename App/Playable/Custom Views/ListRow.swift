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

    var body: some View {
        HStack {
            HStack {
                HStack {
                    Image(model.iconName)
                        .renderingMode(.template)
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(width: 42, height: 42, alignment: .center)
                        .padding(.trailing, 10)

                    VStack(alignment: .leading) {
                        Text(model.name)
                            .font(.system(size: 21, weight: .bold, design: .rounded))
                        
                        if let description = model.description {
                            Text(description)
                                .font(.system(size: 15, weight: .regular, design: .rounded))
                                .foregroundColor(.onSurface.opacity(0.5))
                        }
                    }
                    Spacer()
                }
                .padding()
            }
            .background(.surface)
            .foregroundColor(.onSurface)
            .cornerRadius(13, antialiased: true)
        }
        .padding(EdgeInsets(top: 0, leading: 0, bottom: 0, trailing: 0))
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
