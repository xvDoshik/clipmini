// swift-tools-version: 5.9
import PackageDescription

let package = Package(
    name: "ClipMini",
    platforms: [.macOS(.v14)],
    products: [
        .executable(name: "ClipMini", targets: ["ClipMini"]),
        .library(name: "ClipMiniCore", targets: ["ClipMiniCore"]),
    ],
    targets: [
        .target(name: "ClipMiniCore", path: "Sources/ClipMiniCore"),
        .executableTarget(
            name: "ClipMini",
            dependencies: ["ClipMiniCore"],
            path: "Sources/ClipMini"
        ),
        .executableTarget(
            name: "ClipMiniCoreTests",
            dependencies: ["ClipMiniCore"],
            path: "Tests/ClipMiniCoreTests"
        ),
    ]
)
