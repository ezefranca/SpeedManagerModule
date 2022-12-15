// swift-tools-version: 5.7
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "SpeedManager",
    platforms: [
        .macOS(.v11),
        .iOS(.v15),
        .watchOS(.v8)
    ],
    products: [
        .library(
            name: "SpeedManager",
            targets: ["SpeedManager"]),
    ],
    dependencies: [
        // Dependencies declare other packages that this package depends on.
        // .package(url: /* package url */, from: "1.0.0"),
    ],
    targets: [
        .target(
            name: "SpeedManager",
            dependencies: []),
        .testTarget(
            name: "SpeedManagerTests",
            dependencies: ["SpeedManager"]),
    ],
    swiftLanguageVersions: [SwiftVersion.v5]
)
