//
//  FavoritesTabView.swift
//  Created by Frank Gregor on 27.11.20.
//

import SwiftUI

struct FavoritesTabView: TappableView {
    var tabItemTitle: LocalizedStringKey { TappableViewItem.favorites.titleKey }
    
    var body: some View {
        NavigationView {
            VStack {
            }
            .navigationBarTitle(tabItemTitle)
        }
    }
}

struct FavoritesTabView_Previews: PreviewProvider {
    static var previews: some View {
        FavoritesTabView()
    }
}
