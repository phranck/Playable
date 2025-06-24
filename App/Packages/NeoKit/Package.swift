// swift-tools-version: 6.1

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
