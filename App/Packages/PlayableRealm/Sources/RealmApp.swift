// Playable - 🎧
// This file is part of the Playable project.
// Copyright (c) 2015-2023 Woodbytes, <phranck@mac.com>
//
// Created by: Frank Gregor
// Created at: 03.02.23
//

import Foundation
import RealmSwift

public final class RealmApp {
    public private(set) var realm: Realm

    public init() throws {
        self.realm = try Realm()
    }
}
