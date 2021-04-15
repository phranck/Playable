//
//  TappableView.swift
//  Playable (iOS)
//
//  Created by Frank Gregor on 18.11.20.
//

import SwiftUI

protocol TappableView: View {
    var tabItemTitle: TappableViewTitle { get }
}

enum TappableViewTitle: LocalizedStringKey {
    case devices = "Devices"
    case services = "Services"
    case favorites = "Favorites"
    case settings = "Settings"
}
