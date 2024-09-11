//
//  CGSizeExtension.swift
//  CadrageUI
//
//  Created by Anselm Hartmann on 22.02.22.
//

import CoreGraphics
import Foundation

extension CGSize {
    /// Function to resize a CGSize through multiplication.
    public static func * (left: CGSize, right: CGFloat) -> CGSize {
        return CGSize(
            width: left.width * right,
            height: left.height * right
        )
    }
}

public extension CGSize {
    /// Makes sure that size is not zero.
    var safeSize: CGSize {
        let safeSize = self == .zero ? CGSize(width: 1, height: 1) : self
        return safeSize
    }
}
