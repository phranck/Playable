//
//  ListRow.swift
//  Playable
//
//  Created by Frank Gregor on 26.11.20.
//  Copyright © 2020 Woodbytes. All rights reserved.
//

import SwiftUI

struct ServiceGridItem: View {
    @Environment(\.hapticFeedback) var feedback
    
    var model: ServiceItem

    var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 25, style: .continuous)
                .foregroundColor(.secondarySystemBackground)

            VStack(alignment: .center, spacing: 8) {
                Image(model.iconName)
                    .resizable()
                    .renderingMode(.template)
                    .aspectRatio(contentMode: .fit)
                    .frame(width: 42, height: 42, alignment: .center)
                    .foregroundColor(.primary)

                Text(model.name)
                    .font(.system(.title2, design: .rounded).bold())
                    .foregroundColor(.primary)
                
                if let description = model.description {
                    Text(description)
                        .font(.system(.footnote, design: .rounded))
                        .foregroundColor(.secondary)
                        .multilineTextAlignment(.center)
                }
            }
        }
        .frame(width: 170, height: 150, alignment: .center)
        .padding()
    }
}

// MARK: - Preview

struct ServiceRow_Previews: PreviewProvider {
    static var previews: some View {
        ServiceGridItem(model: ServiceItem(type: .radio))
            .preferredColorScheme(.light)
    }
}
