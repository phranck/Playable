//
//  SettingsView.swift
//  Created by Frank Gregor on 18.11.20.
//

import SwiftUI

struct SettingsTabView: TappableView {
    static var tabItemTitle: LocalizedStringKey { TappableViewItem.settings.titleKey }
    
    var body: some View {
        VStack {
        }
    }
}

struct SettingsView_Previews: PreviewProvider {
    static var previews: some View {
        SettingsTabView()
    }
}
