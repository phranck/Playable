// swift-tools-version: 5.9

import PackageDescription

let package = Package(
    name: "PlayableApplication",
    defaultLocalization: "en",
    platforms: [
        .macOS(.v14),
        .iOS(.v17)
    ],
    products: [
        .library(name: "PlayableApplication", targets: ["PlayableApplication"])
    ],
    dependencies: [
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
                "SDWebImageSwiftUI"
            ],
            path: "Sources",
            plugins: [
            ]
        )
    ]
)
