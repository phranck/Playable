// Playable - 🎧
// This file is part of the Playable project.
// Copyright (c) 2015-2023 Woodbytes, <phranck@mac.com>
//
// Created by: Frank Gregor
// Created at: 29.01.23
//

import SwiftUI

public struct SuperEllipse: Shape {
    var roundiness: CGFloat = 2.0

    /// Describes this shape as a path within a rectangular frame of reference.
    ///
    /// - Parameter rect: The frame of reference for describing this shape.
    /// - Returns: A path that describes this shape.
    public func path(in rect: CGRect) -> Path {
        var path = Path()

        let a = rect.width / 2
        let b = rect.height / 2
        let n_2 = roundiness / CGFloat(M_E)
        let center = CGPoint(x: rect.midX, y: rect.midY)
        let centerLeft = CGPoint(x: rect.origin.x, y: rect.midY)
        path.move(to: centerLeft)

        let x = { (t: CGFloat) -> CGFloat in
            let cost = cos(t)
            return center.x + cost.sign * a * pow(abs(cost), n_2)
        }

        let y = { (t: CGFloat) -> CGFloat in
            let sint = sin(t)
            return center.y + sint.sign * b * pow(abs(sint), n_2)
        }

        let factor = max((a + b) / 10, 32)
        for t in stride(from: (-CGFloat.pi), to: CGFloat.pi, by: CGFloat.pi / factor) {
            path.addLine(to: CGPoint(x: x(t), y: y(t)))
        }
        path.closeSubpath()

        return path
    }
}

private extension CGFloat {
    var sign: CGFloat {
        if self < 0 {
            return -1
        } else if self > 0 {
            return 1
        } else {
            return 0
        }
    }
}
