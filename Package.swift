// swift-tools-version:5.6
import PackageDescription

let package = Package(
    name: "ManagedAppConfigLib",
    platforms: [
        .macOS(.v10_15),
        .iOS(.v8),
        .tvOS(.v10)
    ],
    products: [
        .library(name: "ManagedAppConfigLib", targets: ["ManagedAppConfigLib"])
    ],
    dependencies: [
        .package(url: "https://github.com/apple/swift-docc-plugin", from: "1.0.0")
    ],
    targets: [
        .target(name: "ManagedAppConfigLib"),
        .testTarget(name: "ManagedAppConfigLibTests", dependencies: ["ManagedAppConfigLib"])
    ]
)
