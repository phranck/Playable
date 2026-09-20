// swift-tools-version: 6.0

import PackageDescription

// The three library targets below are shared by the macOS app and the later
// Linux app. PAP-PLY-001 fixes their dependency direction: PlayableAPI and
// PlayableStore may build on PlayableCore, PlayableCore builds on nothing, and
// no shared target ever imports a user interface framework. The repository
// script `scripts/check-shared-swift-modules.mjs` enforces the last part,
// because SwiftPM can express which targets a target sees but not which system
// frameworks it is allowed to import.
//
// The platform floor is the lowest these modules actually need, not the one the
// shipped app will carry. They use Foundation values and Swift Testing and
// nothing else, so raising the floor here would restrict a consumer without
// buying anything. The macOS app declares its own deployment target in Epic 08.
let package = Package(
    name: "PlayableDesktop",
    platforms: [
        .macOS(.v15)
    ],
    products: [
        .library(name: "PlayableCore", targets: ["PlayableCore"]),
        .library(name: "PlayableAPI", targets: ["PlayableAPI"]),
        .library(name: "PlayableStore", targets: ["PlayableStore"])
    ],
    targets: [
        .target(name: "PlayableCore"),
        .target(name: "PlayableAPI", dependencies: ["PlayableCore"]),
        .target(name: "PlayableStore", dependencies: ["PlayableCore"]),
        .testTarget(name: "PlayableCoreTests", dependencies: ["PlayableCore"]),
        .testTarget(name: "PlayableAPITests", dependencies: ["PlayableAPI"]),
        .testTarget(name: "PlayableStoreTests", dependencies: ["PlayableStore"])
    ]
)
