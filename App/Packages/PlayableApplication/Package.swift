// swift-tools-version: 5.8

import PackageDescription

let package = Package(
    name: "PlayableApplication",
    defaultLocalization: "en",
    platforms: [
        .macOS("14.0")
    ],
    products: [
        .library(name: "PlayableApplication", targets: ["PlayableApplication"])
    ],
    dependencies: [
        .package(url: "https://github.com/SwiftyBeaver/SwiftyBeaver.git", from: "1.9.0"),
        .package(url: "https://github.com/realm/SwiftLint.git", from: "0.51.0"),
        .package(url: "https://github.com/SDWebImage/SDWebImageSwiftUI.git", from: "2.0.0"),
        .package(path: "../PlayableFoundation"),
        .package(path: "../PlayableParse")
    ],
    targets: [
        .target(
            name: "PlayableApplication",
            dependencies: [
                "PlayableFoundation",
                "PlayableParse",
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
