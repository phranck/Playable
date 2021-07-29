//
//  TappableView.swift
//  Playable (iOS)
//
//  Created by Frank Gregor on 18.11.20.
//

import SwiftUI

protocol TappableView: View {
    static var tabItemTitle: LocalizedStringKey { get }
}

enum TappableViewItem: Int {
    case devices
    case favorites
    case services
    case settings
    
    var titleKey: LocalizedStringKey {
        switch self {
        case .devices: return LocalizedStringKey("Devices")
        case .favorites: return LocalizedStringKey("Favorites")
        case .services: return LocalizedStringKey("Services")
        case .settings: return LocalizedStringKey("Settings")
        }
    }
    
    var systemImageName: String {
        switch self {
        case .devices: return "hifispeaker.2.fill"
        case .services: return "waveform.path"
        case .favorites: return "heart.fill"
        case .settings: return "switch.2"
        }
    }
}
