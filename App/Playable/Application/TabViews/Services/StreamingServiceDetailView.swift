//
//  StreamingServiceSelectionDetailView.swift
//  Playable
//
//  Created by Frank Gregor on 01.12.20.
//  Copyright © 2020 Woodbytes. All rights reserved.
//

import SwiftUI

struct StreamingServiceDetailView: View {
    @Environment(\.presentationMode) var presentationMode
    var serviceType: StreamingServiceType
    
    var body: some View {
        Group {
            switch self.serviceType {
                case .radio: ServiceSetup(serviceType: .radio)
                case .deezer: ServiceSetup(serviceType: .deezer)
                case .spotify: ServiceSetup(serviceType: .spotify)
                case .soundcloud: ServiceSetup(serviceType: .soundcloud)
                case .tidal: ServiceSetup(serviceType: .tidal)
                case .napster: ServiceSetup(serviceType: .napster)
            }
        }
    }
}
