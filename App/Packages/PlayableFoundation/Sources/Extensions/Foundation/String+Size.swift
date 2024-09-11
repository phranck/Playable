// Playable - 🎧
// This file is part of the Playable project.
// Copyright (c) 2015-2024 Woodbytes, <phranck@mac.com>
//
// Created by: Frank Gregor
// Created at: 11.09.24
//

import Foundation

public extension String {
    /// Returns the bounding box' width of a string regarding the given `Font`.
    /// - Parameter font: The Font used for calculating the width.
    /// - Returns: The calculated width of the string.
    func width(usingFont font: PlatformFont) -> CGFloat {
        return size(usingFont: font).width
    }

    /// Returns the bounding box' height of a string regarding the given `Font`.
    /// - Parameter font: The Font used for calculating the width.
    /// - Returns: The calculated height of the string.
    func height(usingFont font: PlatformFont) -> CGFloat {
        return size(usingFont: font).height
    }

    /// Returns the bounding box' size of a string regarding the given `Font`.
    /// - Parameter font: The Font used for calculating the width.
    /// - Returns: The calculated size of the string.
    func size(usingFont font: PlatformFont) -> CGSize {
        return size(withAttributes: [.font: font])
    }
}
