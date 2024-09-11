//
//  Created by Frank Gregor on 19.04.22.
//

import SwiftUI

public struct Platform: OptionSet {
    public var rawValue: UInt8

    public static let iOS = Platform(rawValue: 1 << 0)
    public static let macOS = Platform(rawValue: 1 << 1)
    public static let tvOS = Platform(rawValue: 1 << 2)
    public static let watchOS = Platform(rawValue: 1 << 3)
    public static let all: Platform = [.iOS, .macOS, .tvOS, .watchOS]
    public static let none: Platform = []

#if os(iOS)
    public static let current: Platform = .iOS
#elseif os(macOS)
    public static let current: Platform = .macOS
#elseif os(tvOS)
    public static let current: Platform = .tvOS
#elseif os(watchOS)
    public static let current: Platform = .watchOS
#endif

    public init(rawValue: UInt8) {
        self.rawValue = rawValue
    }
}

public extension Platform {
    func containsNot(_ platform: Platform) -> Bool {
        !contains(platform)
    }
}
