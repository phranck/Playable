//
//  SettingsView.swift
//  Created by Frank Gregor on 18.11.20.
//

import SwiftUI

struct SettingsTabView: TappableView {
    var tabItemTitle: TappableViewTitle { .settings }
    
    var body: some View {
        NavigationView {
            VStack {
            }
            .navigationBarTitle(tabItemTitle.rawValue, displayMode: .inline)
        }
    }
}

struct SettingsView_Previews: PreviewProvider {
    static var previews: some View {
        SettingsTabView()
    }
}
