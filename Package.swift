// swift-tools-version:5.3
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "OmenTextField",
    platforms: [
        .iOS(.v14),
        .macOS(.v11),
    ],
    products: [
        .library(
            name: "OmenTextField",
            targets: ["OmenTextField"]
        ),
    ],

    targets: [
        .target(
            name: "OmenTextField",
            dependencies: []
        ),
    ]
)
