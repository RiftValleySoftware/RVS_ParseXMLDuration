// swift-tools-version:5.4

import PackageDescription

let package = Package(
    name: "RVS_ParseXMLDuration",
    platforms: [
        .iOS(.v11),
        .tvOS(.v11),
        .macOS(.v10_14),
        .watchOS(.v5)
    ],
    products: [
        .library(
            name: "RVS-ParseXMLDuration",
            targets: ["RVS_ParseXMLDuration"])
    ],
    targets: [
        .target(name: "RVS_ParseXMLDuration"),
        .testTarget(name: "RVS_ParseXMLDurationTests",
                    dependencies: ["RVS_ParseXMLDuration"])
    ]
)
