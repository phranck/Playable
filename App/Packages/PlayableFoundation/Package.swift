// swift-tools-version: 5.9

import PackageDescription

let package = Package(
    name: "PlayableFoundation",
    defaultLocalization: "en",
    platforms: [
        .macOS(.v14),
        .iOS(.v17)
    ],
    products: [
        .library(name: "PlayableFoundation", targets: ["PlayableFoundation"])
    ],
    dependencies: [
    ],
    targets: [
        .target(
            name: "PlayableFoundation",
            dependencies: [],
            path: "Sources",
            plugins: [
            ]
        )
    ]
)
