// swift-tools-version: 5.7
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "PlayableUI",
    platforms: [
        .macOS(.v13)
    ],
    products: [
        .library(name: "PlayableUI", targets: ["PlayableUI"]),
    ],
    dependencies: [
        .package(url: "https://github.com/StefKors/CachedAsyncImage.git", branch: "main"),
        .package(url: "https://github.com/SwiftyBeaver/SwiftyBeaver.git", from: "1.9.0"),
        .package(url: "https://github.com/diniska/swiftui-system-colors.git", from: "1.0.0"),
        .package(url: "https://github.com/realm/SwiftLint.git", branch: "main"),
        .package(path: "../PlayableSDK")
    ],
    targets: [
        .target(
            name: "PlayableUI",
            dependencies: [
                "SwiftyBeaver",
                .product(name: "CachedAsyncImage", package: "CachedAsyncImage"),
                .product(name: "PlayableFoundation", package: "PlayableSDK"),
                .product(name: "PlayableParse", package: "PlayableSDK"),
                .product(name: "SystemColors", package: "swiftui-system-colors")
            ],
            path: "Sources",
            plugins: [
                .plugin(name: "SwiftLintPlugin", package: "SwiftLint")
            ]

        )
    ]
)
