//
//  ServiceSetupRadio.swift
//  Playable
//
//  Created by Frank Gregor on 28.11.20.
//  Copyright © 2020 Woodbytes. All rights reserved.
//

import SwiftUI
import SwiftUIX

struct ServiceSetupRadio: View, StreamingServiceConfigurable {
    @Environment(\.hapticFeedback) var feedback
    @Environment(\.presentationMode) var presentationMode
    
    @State private var searchTerm: String = ""

    var service: StreamingServiceType
    
    var body: some View {
        VStack {
            ScrollView {
                Section(header: ServiceSetupHead(service: service), content: {
                })
                .navigationBarTitle(service.name, displayMode: .inline)
                .navigationBarItems(
                    leading:
                        NavigationBarItem(icon: .navigationBack) {
                            presentationMode.wrappedValue.dismiss()
                        }
                )
                .navigationBarItems(
                    trailing:
                        NavigationBarItem(icon: .search) {
                            log.info("Search tapped")
                        }
                )
                .navigationSearchBar {
                    SearchBar("Placeholder", text: $searchTerm)
                        .showsCancelButton(false)
                        .searchBarStyle(.prominent)
                }
            }
        }
    }
}

struct RadioConfiguration_Previews: PreviewProvider {
    static var previews: some View {
        ServiceSetupRadio(service: .radio)
            .preferredColorScheme(.dark)
    }
}
