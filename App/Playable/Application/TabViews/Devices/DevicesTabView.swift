//
//  DevicesView.swift
//  Created by Frank Gregor on 18.11.20.
//

import SwiftUI
import LinkPlay

struct DevicesTabView: TappableView {
    static var tabItemTitle: LocalizedStringKey { TappableViewItem.devices.titleKey }
    
    @ObservedObject var linkPlay = LinkPlay.shared
    
    var body: some View {
        ScrollView(.vertical, showsIndicators: false) {
            ForEach(Array(linkPlay.devices.sorted { return $0.name < $1.name })) { device in
                Text(device.name)
            }
        }
    }
}

struct DevicesView_Previews: PreviewProvider {
    static var previews: some View {
        DevicesTabView()
    }
}
