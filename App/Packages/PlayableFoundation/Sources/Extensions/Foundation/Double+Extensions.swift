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
