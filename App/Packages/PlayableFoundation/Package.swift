// swift-tools-version: 5.8

import PackageDescription

let package = Package(
    name: "PlayableFoundation",
    defaultLocalization: "en",
    platforms: [
        .macOS(.v13)
    ],
    products: [
        .library(name: "PlayableFoundation", targets: ["PlayableFoundation"])
    ],
    dependencies: [
        .package(url: "https://github.com/SwiftyBeaver/SwiftyBeaver.git", from: "1.9.0"),
        .package(url: "https://github.com/realm/SwiftLint.git", from: "0.51.0")
    ],
    targets: [
        .target(
            name: "PlayableFoundation",
            dependencies: [
                "SwiftyBeaver"
            ],
            path: "Sources",
            plugins: [
                .plugin(name: "SwiftLintPlugin", package: "SwiftLint")
            ]
        )
    ]
)
