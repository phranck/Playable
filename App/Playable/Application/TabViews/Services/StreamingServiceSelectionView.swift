//
//  StreamingServiceSelectionView.swift
//  Playable
//
//  Created by Frank Gregor on 28.11.20.
//  Copyright © 2020 Woodbytes. All rights reserved.
//

import SwiftUI

struct StreamingServiceSelectionView: View {
    @Environment(\.hapticFeedback) var feedback
    @Binding var presentedAsModal: Bool
    @State private var selectedRowItem: StreamingServiceRowItem? = nil

    var body: some View {
        NavigationView {
            VStack {
                ScrollView(.vertical, showsIndicators: false) {
                    LazyVStack(alignment: .leading) {
                        ForEach(services, id: \.self) { serviceRowItem in
                            NavigationLink(
                                destination: StreamingServiceSelectionDetailView(serviceType: serviceRowItem.type),
                                tag: serviceRowItem,
                                selection: $selectedRowItem,
                                label: { EmptyView() }
                            )
                            Button(action: {
                                feedback.impactOccurred()
                                selectedRowItem = serviceRowItem
                            }, label: {
                                ListRow(model: serviceRowItem, hasAccessoryView: true)
                            })
                            .buttonStyle(ListRowButtonStyle())
                        }
                    }
                }
            }
            .navigationTitle(LocalizedStringKey("Select a Service"))
            .navigationBarItems(
                trailing:
                    NavigationBarItem(icon: .navigationAbort, action: {
                        presentedAsModal = false
                    })
                
            )
        }
    }
}

struct StreamingServiceSelectionView_Previews: PreviewProvider {
    @State static var isModal = true
    static var previews: some View {
        StreamingServiceSelectionView(presentedAsModal: $isModal)
            .preferredColorScheme(.dark)
    }
}

struct StreamingServiceRowItem: ListRowItem {
    var type: StreamingServiceType
    var name: String {
        type.name
    }
    var description: LocalizedStringKey {
        type.description
    }
    var iconName: String {
        type.iconName
    }
    var tintColor: Color = .primary
}

// MARK: - Private Helper

private let services: [StreamingServiceRowItem] = [
    StreamingServiceRowItem(type: .radio),
    StreamingServiceRowItem(type: .deezer),
    StreamingServiceRowItem(type: .spotify),
    StreamingServiceRowItem(type: .soundcloud),
    StreamingServiceRowItem(type: .tidal),
    StreamingServiceRowItem(type: .napster),
]
