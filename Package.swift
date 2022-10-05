// swift-tools-version:5.2
import PackageDescription

let package = Package(
    name: "ManagedAppConfigLib",
    platforms: [
        .macOS(.v10_10),
        .iOS(.v11),
        .tvOS(.v9),
        .watchOS(.v2)
    ],
    products: [
        .library(name: "ManagedAppConfigLib", targets: ["ManagedAppConfigLib"])
    ],
    targets: [
        .target(name: "ManagedAppConfigLib"),
        .testTarget(name: "ManagedAppConfigLibTests", dependencies: ["ManagedAppConfigLib"])
    ]
)
