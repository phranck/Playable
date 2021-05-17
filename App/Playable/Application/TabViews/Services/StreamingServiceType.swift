//
//  StreamingServiceType.swift
//  Playable
//
//  Created by Frank Gregor on 29.11.20.
//  Copyright © 2020 Woodbytes. All rights reserved.
//

import SwiftUI

enum StreamingServiceType: String {
    case radio
    case deezer
    case spotify
    case soundcloud
    case tidal
    case napster
    
    public var name: String {
        switch self {
            case .radio: return "Radio"
            case .deezer: return "deezer"
            case .spotify: return "Spotify"
            case .soundcloud: return "Soundcloud"
            case .tidal: return "TIDAL"
            case .napster: return "napster"
        }
    }
    
    public var description: LocalizedStringKey {
        switch self {
            case .radio: return LocalizedStringKey("Streams from all over the world.")
            case .deezer: return LocalizedStringKey("You bring the passion.\nWe bring the music.")
            case .spotify: return LocalizedStringKey("Listening is everything.")
            case .soundcloud: return LocalizedStringKey("Listen to free music and podcasts.")
            case .tidal: return LocalizedStringKey("Clearly the best sound.")
            case .napster: return LocalizedStringKey("Millions of songs anytime, anywhere.")
        }
    }
    
    public var iconName: String {
        return rawValue
    }
    
    public var icon: Image {
        Image(iconName)
    }
    
    public var iconRenderingMode: Image.TemplateRenderingMode {
        switch self {
            case .radio: return .template
            case .deezer: return .template
            case .spotify: return .template
            case .soundcloud: return .template
            case .tidal: return .template
            case .napster: return .template
        }
    }

    public var iconRenderingColor: Color {
        switch self {
            case .radio: return .systemOrange
            case .deezer: return .primary
            case .spotify: return .primary
            case .soundcloud: return .primary
            case .tidal: return .primary
            case .napster: return .systemTeal
        }
    }
    
    public var needsAuthentication: Bool {
        switch self {
            case .radio: return false
            default: return true
        }
    }
}

enum StreamingServiceTypeAuthStatus: Int {
    case locked
    case authenticated
}
