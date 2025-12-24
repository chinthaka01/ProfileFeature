// swift-tools-version: 6.2
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "ProfileFeature",
    platforms: [
        .iOS(.v26)
    ],
    products: [
        // Products define the executables and libraries a package produces, making them visible to other packages.
        .library(
            name: "ProfileFeature",
            targets: ["ProfileFeature"]
        ),
    ],
    dependencies: [
            .package(url: "https://github.com/chinthaka01/PlatformKit.git", .upToNextMajor(from: "1.0.0")),
            .package(url: "https://github.com/chinthaka01/DesignSystem.git", .upToNextMajor(from: "1.0.0"))
    ],
    targets: [
        // Targets are the basic building blocks of a package, defining a module or a test suite.
        // Targets can depend on other targets in this package and products from dependencies.
        .target(
            name: "ProfileFeature",
            dependencies: [
                .product(name: "PlatformKit", package: "PlatformKit"),
                .product(name: "DesignSystem", package: "DesignSystem")
            ]
        ),
        .testTarget(
            name: "ProfileFeatureTests",
            dependencies: ["ProfileFeature"]
        ),
    ]
)
