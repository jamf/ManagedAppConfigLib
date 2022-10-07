// swift-tools-version:5.1
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
    targets: [
        .target(name: "ManagedAppConfigLib"),
        .testTarget(name: "ManagedAppConfigLibTests", dependencies: ["ManagedAppConfigLib"])
    ]
)
