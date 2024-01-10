// NeoKit - 🎛️
// This file is part of the NeoKit project.
// Copyright (c) 2023 Frank Gregor, <phranck@mac.com>
//
// Created by: Frank Gregor
// Created at: 08.12.23
//

import SwiftUI

public extension Color {
    static var neoLighterGrey: Color {
        neoColor(.lighterGrey)
    }

    static var neoLightGrey: Color {
        neoColor(.lightGrey)
    }

    static var neoGrey: Color {
        neoColor(.grey)
    }

    static var neoDarkGrey: Color {
        neoColor(.darkGrey)
    }

    static var neoDarkerGrey: Color {
        neoColor(.darkerGrey)
    }

    static var neoDarkestGrey: Color {
        neoColor(.darkestGrey)
    }

    static var neoAccentOrange: Color {
        neoColor(.accentOrange)
    }

    static var neoAccentGreen: Color {
        neoColor(.accentGreen)
    }

    static var neoText: Color {
        neoColor(.text)
    }

    static var neoBackground: Color {
        neoColor(.background)
    }
}

// MARK: - Private API

private enum NeoColor: String {
    case lighterGrey, lightGrey, grey, darkGrey, darkerGrey, darkestGrey
    case accentOrange, accentGreen
    case text
    case background
}

private extension Color {
    static func neoColor(_ neoColor: NeoColor) -> Color {
        let colorName = "neo\(neoColor.rawValue.capitalized)"
        return Color(colorName, bundle: .module)
    }
}
