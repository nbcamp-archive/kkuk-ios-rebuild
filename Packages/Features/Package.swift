// swift-tools-version: 6.1
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "Features",
    defaultLocalization: "ko",
    platforms: [
        .iOS(.v17),
        .macOS(.v14)
    ],
    products: [
        .library(
            name: "Features",
            targets: ["Features"]
        ),
    ],
    dependencies: [
        .package(name: "Domain", path: "../Domain")
    ],
    targets: [
        .target(
            name: "Features",
            dependencies: ["Domain"]
        ),
        .testTarget(
            name: "FeaturesTests",
            dependencies: ["Features"]
        ),
    ]
)
