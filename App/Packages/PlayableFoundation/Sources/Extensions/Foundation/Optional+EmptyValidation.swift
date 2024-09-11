// Playable - 🎧
// This file is part of the Playable project.
// Copyright (c) 2015-2024 Woodbytes, <phranck@mac.com>
//
// Created by: Frank Gregor
// Created at: 11.09.24
//

import Foundation

public extension Optional where Wrapped: Collection {
    var isNil: Bool {
        self == nil
    }

    var isNotNil: Bool {
        self != nil
    }

    var isEmptyOrNil: Bool {
        self?.isEmpty ?? true
    }

    var isNotEmptyNorNil: Bool {
        !isEmptyOrNil
    }
}

public extension Optional where Wrapped: NSObject {
    var isNil: Bool {
        self == nil
    }

    var isNotNil: Bool {
        self != nil
    }
}
