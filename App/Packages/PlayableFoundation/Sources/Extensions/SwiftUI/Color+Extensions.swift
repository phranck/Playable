
//  Color+Extensions.swift
//  PDF Annotator
//
//  Created by Frank Gregor on 23.07.24.
//

import SwiftUI

public extension Color {
    init(platformColor: PlatformColor) {
#if os(iOS)
        self.init(uiColor: platformColor)
#elseif os(macOS)
        self.init(nsColor: platformColor)
#endif
    }

    init(hexValue: String) {
        var hexValueSanitized = hexValue.trimmingCharacters(in: .whitespacesAndNewlines)
        hexValueSanitized = hexValueSanitized.replacingOccurrences(of: "#", with: "")

        var rgb: UInt64    = 0
        var red: CGFloat   = 0.0
        var green: CGFloat = 0.0
        var blue: CGFloat  = 0.0
        var alpha: CGFloat = 1.0

        let length = hexValueSanitized.count

        guard Scanner(string: hexValueSanitized).scanHexInt64(&rgb) else {
            self = .clear
            return
        }

        if length == 6 {
            red   = CGFloat((rgb & 0xFF0000) >> 16) / 255.0
            green = CGFloat((rgb & 0x00FF00) >> 8) / 255.0
            blue  = CGFloat(rgb & 0x0000FF) / 255.0
        }
        else if length == 8 {
            red   = CGFloat((rgb & 0xFF000000) >> 24) / 255.0
            green = CGFloat((rgb & 0x00FF0000) >> 16) / 255.0
            blue  = CGFloat((rgb & 0x0000FF00) >> 8) / 255.0
            alpha = CGFloat(rgb & 0x000000FF) / 255.0
        }
        else {
            self = .clear
            return
        }

        self.init(red: red, green: green, blue: blue, opacity: alpha)
    }

    var hexValue: String {
        platformColor.hexValue
    }

    var platformColor: PlatformColor {
        PlatformColor(self)
    }
}

// MARK: - Private Helper

public extension PlatformColor {
    var hexValue: String {
        let components = self.components
        return String(
            format: "%02X%02X%02X%02X",
            Int(components.red * 255),
            Int(components.green * 255),
            Int(components.blue * 255),
            Int(components.alpha * 255)
        )
    }

    private var components: (red: CGFloat, green: CGFloat, blue: CGFloat, alpha: CGFloat) {
        var red: CGFloat   = 0
        var green: CGFloat = 0
        var blue: CGFloat  = 0
        var alpha: CGFloat = 0
#if os(iOS)
        getRed(&red, green: &green, blue: &blue, alpha: &alpha)
#elseif os(macOS)
        usingColorSpace(.sRGB)?.getRed(&red, green: &green, blue: &blue, alpha: &alpha)
#endif
        return (red, green, blue, alpha)
    }
}
