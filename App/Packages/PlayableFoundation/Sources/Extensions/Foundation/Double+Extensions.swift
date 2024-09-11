// Playable - 🎧
// This file is part of the Playable project.
// Copyright (c) 2015-2024 Woodbytes, <phranck@mac.com>
//
// Created by: Frank Gregor
// Created at: 11.09.24
//

import Foundation

// MARK: - Value Transformation

public extension Double {
    var intValue: Int { Int(self) }
    var stringValue: String { "\(self)" }
}

// MARK: - Geometric Calculations

public extension Double {
    var normalizeAngle: Double {
        var result = self
        while result > .pi {
            result -= 2 * .pi
        }
        while result < -.pi {
            result += 2 * .pi
        }
        return result
    }
}
