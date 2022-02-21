// swift-tools-version:5.5
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "FindingFalcone",
    products: [
        .library(
            name: "FindingFalcone",
            targets: [
                "FindingFalconeCore",
                "FindingFalconeAPI"
            ]),
    ],
    dependencies: [],
    targets: [
        .target(
            name: "FindingFalconeCore",
            dependencies: []
        ),
        .target(
            name: "FindingFalconeAPI",
            dependencies: ["FindingFalconeCore"]
        ),
        .testTarget(
            name: "FindingFalconeCoreTests",
            dependencies: ["FindingFalconeCore"]
        ),
    ]
)
