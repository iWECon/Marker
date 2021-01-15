// swift-tools-version:5.3
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "Marker",
    platforms: [
        .iOS(.v9)
    ],
    products: [
        .library(name: "Marker", targets: ["Marker"]),
    ],
    targets: [
        .target(name: "Marker", dependencies: [])
    ]
)
