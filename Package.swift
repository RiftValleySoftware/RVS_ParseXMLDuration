// swift-tools-version:5.2

import PackageDescription

let package = Package(
    name: "RVS_ParseXMLDuration",
    platforms: [
        .iOS(.v11),
        .tvOS(.v11),
        .macOS(.v10.14),
        .watchOS(.v5)
    ],
    products: [
        .library(
            name: "RVS-ParseXMLDuration",
            type: .dynamic,
            targets: ["RVS_ParseXMLDuration"])
    ],
    targets: [
        .target(
            name: "RVS_ParseXMLDuration",
            path: "./src")
    ]
)
