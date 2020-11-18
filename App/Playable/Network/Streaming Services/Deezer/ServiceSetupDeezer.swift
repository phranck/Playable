//
//  ServiceSetupDeezer.swift
//  Playable
//
//  Created by Frank Gregor on 02.12.20.
//  Copyright © 2020 Woodbytes. All rights reserved.
//

import SwiftUI
import SwiftUIX

struct ServiceSetupDeezer: View, StreamingServiceConfigurable {
    @Environment(\.hapticFeedback) var feedback
    @Environment(\.presentationMode) var presentationMode

    var service: StreamingServiceType

    var body: some View {
        VStack {
            ScrollView {
                Section(header: ServiceSetupHead(service: service), content: {
                })
                
            }
            Spacer()
        }
        .navigationBarTitle(service.name, displayMode: .inline)
        .navigationBarItems(
            leading:
                NavigationBarItem(icon: .navigationBack) {
                    presentationMode.wrappedValue.dismiss()
                }
        )
    }
}

struct ServiceSetupDeezer_Previews: PreviewProvider {
    static var previews: some View {
        ServiceSetupDeezer(service: .deezer)
            .preferredColorScheme(.dark)
    }
}
