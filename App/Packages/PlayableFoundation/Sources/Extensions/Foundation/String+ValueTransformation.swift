// Playable - 🎧
// This file is part of the Playable project.
// Copyright (c) 2015-2024 Woodbytes, <phranck@mac.com>
//
// Created by: Frank Gregor
// Created at: 11.09.24
//

import Foundation

public extension String {
    var intValue: Int? {
        Int(self)
    }

    var doubleValue: Double? {
        Double(self)
    }

    var floatValue: Float? {
        Float(self)
    }

    var cgFloatValue: CGFloat? {
        if let doubleValue = self.doubleValue {
            return CGFloat(doubleValue)
        }
        return nil
    }

    var nsStringValue: NSString {
        NSString(string: self)
    }
}
