//
//  CGColorExtension.swift
//  CadrageUI
//
//  Created by Anselm Hartmann on 11.01.22.
//

import CoreGraphics
import Foundation

// swiftlint:disable force_unwrapping identifier_name
public extension CGColor {
    /// Extension of CGColor to convert HEX to CGColor and change the color space to "Extended SRGB"
    /// for compatibility with UIColor.
    ///
    /// - Parameters:
    ///   - code: The hexadezimal string of a color represenation (e.g.: "EB34F7, or "#EB34F7")
    ///   - alpha: The opacity of the color. The value ranges from 0 (transparent) to 1 (opaque).
    /// - Returns: A `CGColor` object of the given hexdacimal string if it was valid, otherwise gray color as fallback.
    static func fromHex(_ code: String, alpha: CGFloat = 1.0) -> CGColor {
        let hexCode = code.replacingOccurrences(of: "#", with: "")

        let r = hexCode.startIndex
        let g = hexCode.index(hexCode.startIndex, offsetBy: 2)
        let b = hexCode.index(hexCode.startIndex, offsetBy: 4)

        guard
            let rHex = Int(hexCode[r..<g], radix: 16),
            let gHex = Int(hexCode[g..<b], radix: 16),
            let bHex = Int(hexCode[b...], radix: 16)
        else {
            // Fallback Gray
            return CGColor(red: 0.5, green: 0.5, blue: 0.5, alpha: 1.0)
        }

        // Color Space Extended SRGB
        let color = CGColor(
            colorSpace: .init(name: CGColorSpace.extendedSRGB)!,
            components: [
                CGFloat(rHex) / 0xff,
                CGFloat(gHex) / 0xff,
                CGFloat(bHex) / 0xff,
                alpha
            ]
        )!

        return color
    }

    /// Change a CGColor's brightness
    ///
    /// - Parameter offset: The brightness offset normalized to 0-100.
    /// - Returns: A `CGColor` object if offset was valid, otherwise `nil`.
    func adjustBrightness(by offset: CGFloat) -> CGColor? {
        let components = components

        let newColor = CGColor(
            colorSpace: .init(name: CGColorSpace.extendedSRGB)!,
            components: [
                components![0] + offset / 101,
                components![1] + offset / 101,
                components![2] + offset / 101,
                alpha
            ]
        )

        return newColor
    }
}

public extension CGColor {
    func simulatingAlpha(_ alpha: CGFloat, over color2: CGColor) -> CGColor {
        let whiteComponents: [CGFloat] = [1.0, 1.0, 1.0, 1.0]

        var rgba1: [CGFloat] = whiteComponents //set a valid default
        var rgba2: [CGFloat] = whiteComponents

        if let components = components, components.count > 2 {
            rgba1 = components
        }

        if let components = color2.components, components.count > 2 {
            rgba2 = components
        }

        let r1: CGFloat = rgba1[0]
        let g1: CGFloat = rgba1[1]
        let b1: CGFloat = rgba1[2]

        let r2: CGFloat = rgba2[0]
        let g2: CGFloat = rgba2[1]
        let b2: CGFloat = rgba2[2]

        let r3 = ((1 - alpha) * r2) + (r1 * alpha)
        let g3 = ((1 - alpha) * g2) + (g1 * alpha)
        let b3 = ((1 - alpha) * b2) + (b1 * alpha)

        let newComponents: [CGFloat] = [r3, g3, b3, 1.0]
        let space = CGColorSpace(name: CGColorSpace.sRGB)!
        guard let cgColor3 = CGColor(colorSpace: space, components: newComponents) else {
            print("Failed to create new CGColor in default color space")
            return self
        }

        return cgColor3
    }

    func toUInt32() -> UInt32? {
        guard let components = self.components else { return nil }
        let count = self.numberOfComponents

        var red: CGFloat = 0, green: CGFloat = 0, blue: CGFloat = 0, alpha: CGFloat = 0
        switch count {
        case 1: // grayscale
            red = components[0]
            green = components[0]
            blue = components[0]
            alpha = 1.0
        case 2: // grayscale with alpha
            red = components[0]
            green = components[0]
            blue = components[0]
            alpha = components[1]
        case 3: // RGB
            red = components[0]
            green = components[1]
            blue = components[2]
            alpha = 1.0
        case 4: // RGBA
            red = components[0]
            green = components[1]
            blue = components[2]
            alpha = components[3]
        default:
            return nil
        }

        let redValue = UInt32(red * 255.0) << 16
        let greenValue = UInt32(green * 255.0) << 8
        let blueValue = UInt32(blue * 255.0)
        let alphaValue = UInt32(alpha * 255.0) << 24

        return alphaValue | redValue | greenValue | blueValue
    }
}
