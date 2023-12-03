// Playable - 🎧
// This file is part of the Playable project.
// Copyright (c) 2015-2022 Woodbytes, <phranck@mac.com>
//
// Created by: Frank Gregor
// Created at: 19.12.22
//

import Foundation

public struct Coverart: Identifiable, Hashable {
    public var id: String { name }

    public var name: String
    public var urlString: String
}

public extension Coverart {
    var url: URL {
        // swiftlint:disable force_unwrapping
        return URL(string: urlString)!
        // swiftlint:enable force_unwrapping
    }
}

extension Coverart: Codable {
    enum CodingKeys: String, CodingKey {
        case name
        case urlString = "url"
    }
}
