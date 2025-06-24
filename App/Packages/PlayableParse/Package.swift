// swift-tools-version: 6.1

import PackageDescription

let package = Package(
    name: "PlayableParse",
    defaultLocalization: "en",
    platforms: [
        .macOS(.v14),
        .iOS(.v17)
    ],
    products: [
        .library(name: "PlayableParse", targets: ["PlayableParse"])
    ],
    dependencies: [
        .package(url: "https://github.com/parse-community/Parse-Swift", from: "4.0.0"),
        .package(path: "../PlayableFoundation")
    ],
    targets: [
        .target(
            name: "PlayableParse",
            dependencies: [
                "PlayableFoundation",
                .product(name: "ParseSwift", package: "Parse-Swift")
            ],
            path: "Sources",
            plugins: [
            ]
        )
    ]
)
