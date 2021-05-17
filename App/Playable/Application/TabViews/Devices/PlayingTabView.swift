//
//  DevicesView.swift
//  Created by Frank Gregor on 18.11.20.
//

import SwiftUI

struct PlayingTabView: TappableView {
    var tabItemTitle: LocalizedStringKey { TappableViewItem.playing.titleKey }
    
    var body: some View {
        NavigationView {
            VStack {
            }
            .navigationBarTitle(tabItemTitle)
        }
    }
}

struct DevicesView_Previews: PreviewProvider {
    static var previews: some View {
        PlayingTabView()
    }
}
