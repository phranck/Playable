//
//  DevicesView.swift
//  Created by Frank Gregor on 18.11.20.
//

import SwiftUI

struct DevicesTabView: TappableView {
    var tabItemTitle: TappableViewTitle { .devices }
    
    var body: some View {
        NavigationView {
            VStack {
            }
            .navigationBarTitle(tabItemTitle.rawValue, displayMode: .inline)
        }
    }
}

struct DevicesView_Previews: PreviewProvider {
    static var previews: some View {
        DevicesTabView()
    }
}
