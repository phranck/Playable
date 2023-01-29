// swift-tools-version: 5.7
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "PlayableLiveSDK",
    defaultLocalization: "en",
    platforms: [
        .iOS("16.1"),
        .macOS(.v13)
    ],
    products: [
        .library(name: "PlayableFoundation", targets: ["PlayableFoundation"]),
        .library(name: "PlayableParse", targets: ["PlayableParse"])
    ],
    dependencies: [
        .package(url: "https://github.com/parse-community/Parse-Swift", from: "4.0.0"),
        .package(url: "https://github.com/SFSafeSymbols/SFSafeSymbols.git", from: "4.0.0"),
        .package(url: "https://github.com/SwiftyBeaver/SwiftyBeaver.git", from: "1.9.0"),
        .package(url: "https://github.com/realm/SwiftLint.git", branch: "main")
    ],
    targets: [
        .target(
            name: "PlayableFoundation",
            dependencies: [
                "SwiftyBeaver",
                "SFSafeSymbols"
            ],
            path: "Modules/Foundation",
            plugins: [
                .plugin(name: "SwiftLintPlugin", package: "SwiftLint")
            ]
        ),
        .target(
            name: "PlayableParse",
            dependencies: [
                "PlayableFoundation",
                "SwiftyBeaver",
                .product(name: "ParseSwift", package: "Parse-Swift")
            ],
            path: "Modules/Parse",
            plugins: [
                .plugin(name: "SwiftLintPlugin", package: "SwiftLint")
            ]
        )
    ]
)
