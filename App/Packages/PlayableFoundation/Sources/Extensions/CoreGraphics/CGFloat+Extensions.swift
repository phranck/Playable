
//  CGPoint+Extensions.swift
//  PDF Annotator
//
//  Created by Frank Gregor on 04.09.24.
//

import Foundation

public extension CGFloat {
    func isWithinXBounds(of rect: CGRect) -> Bool {
        self >= rect.minX && self <= rect.maxX
    }
}
