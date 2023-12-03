//
// Playable - 🎧
// This file is part of the Playable project.
// Copyright (c) 2015-2022 Woodbytes, <phranck@mac.com>
//
// Created by: Frank Gregor
// Created at: 01.12.22
//

import Foundation

// swiftlint:disable force_unwrapping
public extension Bundle {
    static var parseApplicationId: String {
        Bundle.value(for: "PARSE_APPLICATION_ID")
    }

    static var parseClientKey: String {
        Bundle.value(for: "PARSE_CLIENT_KEY")
    }

    static var parseServerUrl: URL {
        URL(string: "https://\(Bundle.value(for: "PARSE_SERVER_URL"))")!
    }

    static var appGroupId: String {
        Bundle.value(for: "APP_GROUP_ID")
    }
}

// MARK: - Private API

private extension Bundle {
    static func value(for key: String) -> String {
        guard let value = Bundle.main.object(forInfoDictionaryKey: key) as? String else {
            fatalError("No value for key '\(key)' in Info.plist found!")
        }
        return value
    }
}
// swiftlint:enable force_unwrapping
