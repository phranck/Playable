// Playable - 🎧
// This file is part of the Playable project.
// Copyright (c) 2015-2024 Woodbytes, <phranck@mac.com>
//
// Created by: Frank Gregor
// Created at: 11.09.24
//

import Foundation

public extension Sequence {
    @inlinable func doesNotContain(where predicate: (Self.Element) throws -> Bool) rethrows -> Bool {
        try !contains(where: predicate)
    }
}

public extension Collection {
    @inlinable var isNotEmpty: Bool {
        !isEmpty
    }
}
