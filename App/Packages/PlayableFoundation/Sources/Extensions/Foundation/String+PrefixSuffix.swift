// Playable - 🎧
// This file is part of the Playable project.
// Copyright (c) 2015-2024 Woodbytes, <phranck@mac.com>
//
// Created by: Frank Gregor
// Created at: 11.09.24
//

import Foundation

public extension String {
    /// Removes the specified prefix if present in string
    @inlinable func remove(prefix: String) -> String {
        guard self.hasPrefix(prefix) else { return self }

        var newString = self
        newString.trimPrefix(prefix)
        return newString
    }
    
    /// Removes the specified suffix if present in string
    @inlinable func remove(suffix: String) -> String {
        guard self.hasSuffix(suffix) else { return self }

        let endIndex = self.index(self.endIndex, offsetBy: -suffix.count)
        return String(self[..<endIndex])
    }
}
