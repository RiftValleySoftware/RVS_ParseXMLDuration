// swift-tools-version:5.5

import PackageDescription

let package = Package(
    name: "RVS_ParseXMLDuration",
    platforms: [
        .iOS(.v13),
        .tvOS(.v13),
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
        .testTarget(name: "RVS-ParseXMLDurationTests",
                    dependencies: ["RVS_ParseXMLDuration"],
                    path: "Tests/RVS_ParseXMLDurationTests")
    ]
)
