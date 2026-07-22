// swift-tools-version:5.9
import PackageDescription

let package = Package(
    name: "ManagedAppConfigLib",
    platforms: [
        .macOS(.v13),
        .iOS(.v17),
        .tvOS(.v17)
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
