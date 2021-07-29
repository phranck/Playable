//
//  ServiceSetup.swift
//  Playable
//
//  Created by Frank Gregor on 17.05.21.
//  Copyright © 2021 Woodbytes. All rights reserved.
//

import SwiftUI

protocol StreamingServiceConfigurable {
    var serviceType: ServiceType { get set }
}

struct ServiceSetup: View, StreamingServiceConfigurable {
    var serviceType: ServiceType

    var body: some View {
        VStack {
            switch self.serviceType {
                case .radio: ServiceSetupRadio()
                case .deezer: ServiceSetupDeezer()
                case .spotify: EmptyView()
                case .soundcloud: EmptyView()
                case .tidal: EmptyView()
                case .napster: EmptyView()
            }
        }
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItem(placement: .principal) {
                HStack {
                    serviceTypeIcon
                    
                    Text(serviceType.name)
                        .font(.headline)
                }
            }
        }
    }
    
    var serviceTypeIcon: some View {
        serviceType.icon
            .renderingMode(serviceType.iconRenderingMode)
            .resizable()
            .scaledToFit()
            .frame(width: 20)
    }
    
}
