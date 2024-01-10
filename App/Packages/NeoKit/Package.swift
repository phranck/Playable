// swift-tools-version: 5.9

import PackageDescription

let package = Package(
    name: "NeoKit",
    defaultLocalization: "en",
    platforms: [
        .macOS(.v14),
        .iOS(.v17)
    ],
    products: [
        .library(name: "NeoKit", targets: ["NeoKit"]),
    ],
    targets: [
        .target(name: "NeoKit"),
    ]
)
