// swift-tools-version: 5.7

import PackageDescription

let package = Package(
    name: "PlayableApplication",
    defaultLocalization: "en",
    platforms: [
        .iOS("16.1"),
        .macOS(.v13)
    ],
    products: [
        .library(name: "PlayableApplication", targets: ["PlayableApplication"])
    ],
    dependencies: [
        .package(url: "https://github.com/SwiftyBeaver/SwiftyBeaver.git", from: "1.9.0"),
        .package(url: "https://github.com/realm/SwiftLint.git", branch: "main"),
        .package(url: "https://github.com/diniska/swiftui-system-colors.git", from: "1.0.0"),
        .package(url: "https://github.com/SFSafeSymbols/SFSafeSymbols.git", from: "4.0.0"),
        .package(url: "https://github.com/pointfreeco/swiftui-navigation.git", from: "0.5.0"),
        .package(url: "https://github.com/pointfreeco/swift-dependencies.git", from: "0.1.4"),
        .package(url: "https://github.com/SDWebImage/SDWebImageSwiftUI.git", from: "2.0.0"),
        .package(path: "../PlayableFoundation"),
        .package(path: "../PlayableParse"),
        .package(path: "../PlayableRealm")
    ],
    targets: [
        .target(
            name: "PlayableApplication",
            dependencies: [
                "PlayableFoundation",
                "PlayableParse",
                "PlayableRealm",
                "SDWebImageSwiftUI",
                "SwiftyBeaver"
            ],
            path: "Sources",
            plugins: [
                .plugin(name: "SwiftLintPlugin", package: "SwiftLint")
            ]
        )
    ]
)
