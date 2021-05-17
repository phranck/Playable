//
//  TappableView.swift
//  Playable (iOS)
//
//  Created by Frank Gregor on 18.11.20.
//

import SwiftUI

protocol TappableView: View {
    var tabItemTitle: LocalizedStringKey { get }
}

enum TappableViewItem: Int {
    case playing
    case favorites
    case services
    case settings
    
    var titleKey: LocalizedStringKey {
        switch self {
            case .playing: return LocalizedStringKey("Playing")
            case .favorites: return LocalizedStringKey("Favorites")
            case .services: return LocalizedStringKey("Services")
            case .settings: return LocalizedStringKey("Settings")
        }
    }
    
    var systemImageName: String {
        switch self {
            case .playing: return "hifispeaker.2.fill"
            case .favorites: return "heart.fill"
            case .services: return "music.quarternote.3"
            case .settings: return "gearshape.fill"
        }
    }
}
