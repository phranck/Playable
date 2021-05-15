//
//  Color+UISystemColors.swift
//  Playable
//
//  Created by Frank Gregor on 26.11.20.
//  Copyright © 2020 Woodbytes. All rights reserved.
//

import SwiftUI

extension Color {
    // MARK: - Application specific Colors
    
    // MARK: - Text Colors
    static let lightText = Color(UIColor.lightText)
    static let darkText = Color(UIColor.darkText)
    static let placeholderText = Color(UIColor.placeholderText)
    
    // MARK: - Label Colors
    static let label = Color(UIColor.label)
    static let secondaryLabel = Color(UIColor.secondaryLabel)
    static let tertiaryLabel = Color(UIColor.tertiaryLabel)
    static let quaternaryLabel = Color(UIColor.quaternaryLabel)
    
    // MARK: - Background Colors
    static let systemBackground = Color(UIColor.systemBackground)
    static let secondarySystemBackground = Color(UIColor.secondarySystemBackground)
    static let tertiarySystemBackground = Color(UIColor.tertiarySystemBackground)
    
    // MARK: - Fill Colors
    static let systemFill = Color(UIColor.systemFill)
    static let secondarySystemFill = Color(UIColor.secondarySystemFill)
    static let tertiarySystemFill = Color(UIColor.tertiarySystemFill)
    static let quaternarySystemFill = Color(UIColor.quaternarySystemFill)
    
    // MARK: - Grouped Background Colors
    static let systemGroupedBackground = Color(UIColor.systemGroupedBackground)
    static let secondarySystemGroupedBackground = Color(UIColor.secondarySystemGroupedBackground)
    static let tertiarySystemGroupedBackground = Color(UIColor.tertiarySystemGroupedBackground)
    
    // MARK: - Gray Colors
    static let systemGray = Color(UIColor.systemGray)
    static let systemGray2 = Color(UIColor.systemGray2)
    static let systemGray3 = Color(UIColor.systemGray3)
    static let systemGray4 = Color(UIColor.systemGray4)
    static let systemGray5 = Color(UIColor.systemGray5)
    static let systemGray6 = Color(UIColor.systemGray6)
    
    // MARK: - Other Colors
    static let separator = Color(UIColor.separator)
    static let opaqueSeparator = Color(UIColor.opaqueSeparator)
    static let link = Color(UIColor.link)
    
    // MARK: - System Colors
    static let systemBlue = Color(UIColor.systemBlue)
    static let systemPurple = Color(UIColor.systemPurple)
    static let systemGreen = Color(UIColor.systemGreen)
    static let systemYellow = Color(UIColor.systemYellow)
    static let systemOrange = Color(UIColor.systemOrange)
    static let systemPink = Color(UIColor.systemPink)
    static let systemRed = Color(UIColor.systemRed)
    static let systemTeal = Color(UIColor.systemTeal)
    static let systemIndigo = Color(UIColor.systemIndigo)
    
}

extension Color {
    
    /// Primary #232424
    static var primary: Color {
        return Color(red: 0.137, green: 0.141, blue: 0.141, opacity: 1.0)
    }
    
    /// On Primary #fffce8
    static var onPrimary: Color {
        return Color(red: 1.0, green: 0.988, blue: 0.91, opacity: 1.0)
    }
    
    /// Secondary #232424
    static var secondary: Color {
        return Color(red: 0.137, green: 0.143, blue: 0.142, opacity: 1.0)
    }
    
    /// On Secondary #535253
    static var onSecondary: Color {
        return Color(red: 0.327, green: 0.322, blue: 0.326, opacity: 1.0)
    }
    
    /// Background #1f1f1f
    static var background: Color {
        return Color("background")
    }
    
    /// On Background #fefefe
    static var onBackground: Color {
        return Color("onBackground")
    }
    
    /// Surface #353434
    static var surface: Color {
        return Color(red: 0.209, green: 0.203, blue: 0.204, opacity: 1.0)
    }
    
    /// On Surface #fffbe8
    static var onSurface: Color {
        return Color(red: 0.999, green: 0.986, blue: 0.909, opacity: 1.0)
    }
    
    /// Error #b00020
    static var error: Color {
        return Color(red: 0.69, green: 0.0, blue: 0.127, opacity: 1.0)
    }
    
    /// On Error #fffce8
    static var onError: Color {
        return Color(red: 1.0, green: 0.987, blue: 0.91, opacity: 1.0)
    }

    /// Accent #93d402
    static var accent: Color {
        return Color(red: 0.575, green: 0.831, blue: 0.008, opacity: 1.0)
    }

    /// On Accent #fffce8
    static var onAccent: Color {
        return Color(red: 1.0, green: 0.988, blue: 0.91, opacity: 1.0)
    }
    

}
