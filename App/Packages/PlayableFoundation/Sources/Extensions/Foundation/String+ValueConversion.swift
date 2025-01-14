// Playable - 🎧
// This file is part of the Playable project.
// Copyright (c) 2015-2024 Woodbytes, <phranck@mac.com>
//
// Created by: Frank Gregor
// Created at: 11.09.24
//

import Foundation

public extension String {
    var boolValue: Bool {
        (self as NSString).boolValue
    }

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
        guard let doubleValue = self.doubleValue else { return nil }
        return CGFloat(doubleValue)
    }

    var nsStringValue: NSString {
        NSString(string: self)
    }
}
