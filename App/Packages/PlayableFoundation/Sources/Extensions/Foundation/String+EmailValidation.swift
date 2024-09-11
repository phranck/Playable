// Playable - 🎧
// This file is part of the Playable project.
// Copyright (c) 2015-2024 Woodbytes, <phranck@mac.com>
//
// Created by: Frank Gregor
// Created at: 11.09.24
//

import SwiftUI

public extension String {
    /// Check if the string seems to be a valid email address. Only very basic check for correct email address format and valid characters.
    /// - Returns: Bool, that indicates, if the string seems to be a email address.
    var isEmailAddress: Bool {
        guard
            let range = self.range(of: "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}", options: [.regularExpression, .caseInsensitive]),
            range.lowerBound == self.startIndex && range.upperBound == self.endIndex
        else {
            return false
        }
        return true
    }
}
