//
//  ServicesView.swift
//  Created by Frank Gregor on 18.11.20.
//

import SwiftUI

struct ServicesTabView: TappableView {
    var tabItemTitle: LocalizedStringKey { TappableViewItem.services.titleKey }

    @Environment(\.hapticFeedback) var feedback

    var body: some View {
        NavigationView {
            ScrollView(.vertical, showsIndicators: false) {
                ForEach(services, id: \.self) { serviceItemModel in
                    NavigationLink(destination: StreamingServiceDetailView(serviceType: serviceItemModel.type)) {
                        ListRowItem(model: serviceItemModel)
                    }
                    .buttonStyle(ListRowButtonStyle())
                }
            }
            .navigationBarTitle(tabItemTitle)
        }
    }
}

struct ServicesView_Previews: PreviewProvider {
    static var previews: some View {
        ServicesTabView()
    }
}

// MARK: - Private Helper

struct StreamingServiceRowItem: ListRowItemModel {
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
}

private let services: [StreamingServiceRowItem] = [
    StreamingServiceRowItem(type: .radio),
    StreamingServiceRowItem(type: .deezer),
    StreamingServiceRowItem(type: .spotify),
    StreamingServiceRowItem(type: .soundcloud),
    StreamingServiceRowItem(type: .tidal),
    StreamingServiceRowItem(type: .napster),
]
