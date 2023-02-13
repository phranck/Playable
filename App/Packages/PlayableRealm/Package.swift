// swift-tools-version: 5.7

import PackageDescription

let package = Package(
    name: "PlayableRealm",
    defaultLocalization: "en",
    platforms: [
        .iOS("16.1"),
        .macOS(.v13)
    ],
    products: [
        .library(name: "PlayableRealm", targets: ["PlayableRealm"])
    ],
    dependencies: [
        .package(url: "https://github.com/realm/realm-swift.git", from: "10.32.0"),
        .package(url: "https://github.com/realm/SwiftLint.git", branch: "main"),
        .package(url: "https://github.com/SwiftyBeaver/SwiftyBeaver.git", from: "1.9.0")
    ],
    targets: [
        .target(
            name: "PlayableRealm",
            dependencies: [
                "SwiftyBeaver",
                .product(name: "RealmSwift", package: "realm-swift")
            ],
            path: "Sources",
            plugins: [
                .plugin(name: "SwiftLintPlugin", package: "SwiftLint")
            ]
        )
    ]
)
