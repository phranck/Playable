//
// Playable - 🎧
// This file is part of the Playable project.
// Copyright (c) 2015-2022 Woodbytes, <phranck@mac.com>
//
// Created by: Frank Gregor
// Created at: 03.12.22
//

import Foundation

public extension UserDefaults {
    struct GroupDefaults {
        private let defaults = UserDefaults(suiteName: Bundle.appGroupId)

        public static let shared = GroupDefaults()
        private init() {}
    }

    static let groupDefaults = GroupDefaults.shared
}

public extension UserDefaults.GroupDefaults {
    var username: String {
        defaults?.string(forKey: "username") ?? ""
    }

    var email: String {
        defaults?.string(forKey: "email") ?? ""
    }
}
