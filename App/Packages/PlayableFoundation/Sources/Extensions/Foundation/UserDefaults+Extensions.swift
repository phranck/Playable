//
// Cadrage Studio - 🎬
// This file is part of the Cadrage Studio project.
// Copyright (C) 2021-2022 Cadrage GmbH, <support@cadrage.app>
//
// Created by: Frank Gregor
// Created at: 11.11.22
//

import Foundation

public extension UserDefaults {
    static func resetDefaults() {
        let defaults = UserDefaults.standard
        let dictionary = defaults.dictionaryRepresentation()
        dictionary.keys.forEach { key in
            defaults.removeObject(forKey: key)
        }
    }

    static var firstLoginComplete: Bool {
        get {
            standard.bool(forKey: Keys.firstLoginComplete.rawValue)
        }
        set {
            standard.set(newValue, forKey: Keys.firstLoginComplete.rawValue)
        }
    }
}

private extension UserDefaults {
    enum Keys: String, CaseIterable {
        case firstLoginComplete
    }
}
