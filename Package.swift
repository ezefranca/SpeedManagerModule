// swift-tools-version: 5.7
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "SpeedManagerModule",
    platforms: [
        .macOS(.v12),
        .iOS(.v15),
        .watchOS(.v8)
    ],
    products: [
        .library(
            name: "SpeedManagerModule",
            targets: ["SpeedManagerModule"]),
    ],
    dependencies: [
        // Dependencies declare other packages that this package depends on.
        // .package(url: /* package url */, from: "1.0.0"),
    ],
    targets: [
        .target(
            name: "SpeedManagerModule",
            dependencies: []),
        .testTarget(
            name: "SpeedManagerModuleTests",
            dependencies: ["SpeedManagerModule"]),
    ]
)
