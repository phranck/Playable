//
//  ServiceSetup.swift
//  Playable
//
//  Created by Frank Gregor on 17.05.21.
//  Copyright © 2021 Woodbytes. All rights reserved.
//

import SwiftUI

struct ServiceSetup: View, StreamingServiceConfigurable {
    var serviceType: StreamingServiceType

    var body: some View {
        Group {
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
                NavigationBarTitleView(service: serviceType)
            }
        }
    }
    
}
