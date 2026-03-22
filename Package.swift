// swift-tools-version: 5.9
import PackageDescription

let package = Package(
    name: "FiltreProgrami",
    platforms: [
        .iOS(.v16),
        .macOS(.v13)
    ],
    products: [
        .library(name: "MessageFilteringDomain", targets: ["MessageFilteringDomain"]),
        .library(name: "ClassificationCore", targets: ["ClassificationCore"]),
        .library(name: "RulesEngine", targets: ["RulesEngine"]),
        .library(name: "Dataset", targets: ["Dataset"])
    ],
    targets: [
        .target(
            name: "MessageFilteringDomain"
        ),
        .target(
            name: "RulesEngine",
            dependencies: ["MessageFilteringDomain"]
        ),
        .target(
            name: "ClassificationCore",
            dependencies: ["MessageFilteringDomain", "RulesEngine"]
        ),
        .target(
            name: "Dataset",
            dependencies: ["MessageFilteringDomain"]
        ),
        .testTarget(
            name: "ClassificationCoreTests",
            dependencies: ["ClassificationCore", "Dataset", "MessageFilteringDomain", "RulesEngine"]
        )
    ]
)
