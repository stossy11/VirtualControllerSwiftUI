// swift-tools-version:5.5
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "VirtualControllerSwiftUI",
    platforms: [
        .iOS(.v13),         //.v8 - .v13
        .macOS(.v10_15),    //.v10_10 - .v10_15
        .tvOS(.v13),        //.v9 - .v13
        .watchOS(.v6),      //.v2 - .v6
    ],
    products: [
        .library(
            name: "VirtualControllerSwiftUI",
            targets: ["VirtualControllerSwiftUI"]),
    ],
    targets: [
        .target(
            name: "VirtualControllerSwiftUI"),
    ]
)
