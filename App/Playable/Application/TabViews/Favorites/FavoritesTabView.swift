//
//  FavoritesTabView.swift
//  Playable
//
//  Created by Frank Gregor on 27.11.20.
//  Copyright © 2020 Woodbytes. All rights reserved.
//

import SwiftUI

struct FavoritesTabView: TappableView {
    var tabItemTitle: TappableViewTitle { .favorites }
    
    var body: some View {
        NavigationView {
            VStack {
            }
            .navigationTitle(tabItemTitle.rawValue)
        }
    }
}

struct FavoritesTabView_Previews: PreviewProvider {
    static var previews: some View {
        FavoritesTabView()
    }
}
