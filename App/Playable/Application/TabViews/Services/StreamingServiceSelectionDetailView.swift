//
//  StreamingServiceSelectionDetailView.swift
//  Playable
//
//  Created by Frank Gregor on 01.12.20.
//  Copyright © 2020 Woodbytes. All rights reserved.
//

import SwiftUI

struct StreamingServiceSelectionDetailView: View {
    @Environment(\.hapticFeedback) var feedback
    @Environment(\.presentationMode) var presentationMode
    var serviceType: StreamingServiceType
    
    var body: some View {
        Group {
            switch self.serviceType {
                case .radio: ServiceSetupRadio(service: .radio)
                case .deezer: ServiceSetupDeezer(service: .deezer)
                case .spotify: Text(serviceType.name)
                case .soundcloud: Text(serviceType.name)
                case .tidal: Text(serviceType.name)
                case .napster: Text(serviceType.name)
            }
        }
        .navigationBarBackButtonHidden(true)
        .navigationBarItems(
            leading:
                NavigationBarItem(icon: .navigationBack) {
                    presentationMode.wrappedValue.dismiss()
                }
        )
    }
}
