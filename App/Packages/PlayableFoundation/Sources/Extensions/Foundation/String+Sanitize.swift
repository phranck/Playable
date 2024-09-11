// Playable - 🎧
// This file is part of the Playable project.
// Copyright (c) 2015-2024 Woodbytes, <phranck@mac.com>
//
// Created by: Frank Gregor
// Created at: 11.09.24
//

import Foundation

public extension String {
    var sanitized: String {
        let invalidCharacters = CharacterSet(charactersIn: "\\/:*?\"<>|")
            .union(.newlines)
            .union(.illegalCharacters)
            .union(.controlCharacters)

        return self
            .components(separatedBy: invalidCharacters)
            .joined(separator: "")
    }

    mutating func sanitize() {
        self = sanitized
    }

    var whitespaceCondensed: String {
        return self.components(separatedBy: .whitespacesAndNewlines)
            .filter { !$0.isEmpty }
            .joined(separator: " ")
    }

    mutating func condenseWhitespace() {
        self = whitespaceCondensed
    }
}
