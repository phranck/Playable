//
//  CGRectExtension.swift
//  CadrageUI
//
//  Created by Anselm Hartmann on 22.02.22.
//

import CoreGraphics
import Foundation

public extension CGRect {
    /// Centered `CGPoint` coordinate of the receiving rectangle.
    var center: CGPoint {
        get { return CGPoint(x: centerX, y: centerY) }
        set { centerX = newValue.x; centerY = newValue.y }
    }

    /// Centered x-coordinate of the receiving rectangle.
    ///
    /// - Note: Acts as a settable midX
    /// - Returns: The entered x-coordinate
    var centerX: CGFloat {
        get { return midX }
        set { origin.x = newValue - width * 0.5 }
    }

    /// Centered y-coordinate of the receiving rectangle.
    ///
    /// - Note: Acts as a settable midY
    /// - Returns: The entered y-coordinate
    var centerY: CGFloat {
        get { return midY }
        set { origin.y = newValue - height * 0.5 }
    }
}

public extension CGRect {
    static func * (left: CGRect, right: CGFloat) -> CGRect {
        return CGRect(
            x: left.origin.x * right,
            y: left.origin.y * right,
            width: left.width * right,
            height: left.height * right
        )
    }

    func doesNotIntersect(_ rhsRect: CGRect) -> Bool {
        !intersects(rhsRect)
    }

    func hasGreaterMinX(than rhsRect: CGRect) -> Bool {
        minX > rhsRect.minX
    }

    func hasLesserMinX(than rhsRect: CGRect) -> Bool {
        minX < rhsRect.minX
    }

    func hasGreaterMaxX(than rhsRect: CGRect) -> Bool {
        maxX > rhsRect.maxX
    }

    func hasLesserMaxX(than rhsRect: CGRect) -> Bool {
        maxX < rhsRect.maxX
    }
}
