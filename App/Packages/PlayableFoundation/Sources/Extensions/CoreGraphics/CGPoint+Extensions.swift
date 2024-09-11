// Cadrage Studio - 🎬
// This file is part of the Cadrage Studio project.
// Copyright (C) 2021-2023 Cadrage GmbH, <support@cadrage.app>
//
// Created by: Frank Gregor
// Created at: 23.08.23
//

import Foundation

public extension CGPoint {
    static func - (lhs: CGPoint, rhs: CGPoint) -> CGPoint {
        CGPoint(x: lhs.x - rhs.x, y: lhs.y - rhs.y)
    }

    static func + (lhs: CGPoint, rhs: CGPoint) -> CGPoint {
        CGPoint(x: lhs.x + rhs.x, y: lhs.y + rhs.y)
    }
}
