//
//  ServiceItem.swift
//  ServiceItem
//
//  Created by Frank Gregor on 16.07.21.
//  Copyright © 2021 Woodbytes. All rights reserved.
//

import SwiftUI

struct ServiceItem: Hashable {
    var type: ServiceType
    var name: String {
        type.name
    }
    var description: LocalizedStringKey {
        type.description
    }
    var iconName: String {
        type.iconName
    }
}

struct ServiceItem_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            ServiceGridItem(model: ServiceItem(type: .radio))
                .preferredColorScheme(.dark)
                .frame(width: .infinity, height: 80, alignment: .center)
        }
        .background(Color.systemGray)
        .frame(width: .infinity, height: .infinity, alignment: .center)
    }
}
