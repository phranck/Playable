// swift-tools-version: 5.7

import PackageDescription

let package = Package(
    name: "PlayableParse",
    defaultLocalization: "en",
    platforms: [
        .iOS("16.1"),
        .macOS(.v13)
    ],
    products: [
        .library(name: "PlayableParse", targets: ["PlayableParse"])
    ],
    dependencies: [
        .package(url: "https://github.com/parse-community/Parse-Swift", from: "4.0.0"),
        .package(url: "https://github.com/SwiftyBeaver/SwiftyBeaver.git", from: "1.9.0"),
        .package(url: "https://github.com/realm/SwiftLint.git", branch: "main"),
        .package(path: "../PlayableFoundation")
    ],
    targets: [
        .target(
            name: "PlayableParse",
            dependencies: [
                "PlayableFoundation",
                "SwiftyBeaver",
                .product(name: "ParseSwift", package: "Parse-Swift")
            ],
            path: "Sources",
            plugins: [
                .plugin(name: "SwiftLintPlugin", package: "SwiftLint")
            ]
        )
    ]
)
