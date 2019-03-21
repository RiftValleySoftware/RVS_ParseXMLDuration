import PackageDescription

let package = Package(
    name: "RVS_ParseXMLDuration",
    products: [
        .library(
            name: "RVS_ParseXMLDuration",
            targets: ["RVS_ParseXMLDuration"]
        )
    ],
    targets: [
        .target(
            name: "RVS_ParseXMLDuration",
            path: "RVS_ParseXMLDuration"
        )
    ],
    swiftLanguageVersions: [
        4.2
    ]
)
