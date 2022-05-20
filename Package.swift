// swift-tools-version:5.3
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "ChatUI",
    defaultLocalization: "ru",
    platforms: [.iOS(.v13)],
    products: [
        // Products define the executables and libraries a package produces, and make them visible to other packages.
        .library(
            name: "ChatUI",
            targets: ["ChatUI"]),
    ],
    dependencies: [
        // Dependencies declare other packages that this package depends on.
        .package(url: "https://github.com/MessageKit/MessageKit", Package.Dependency.Requirement.exact("3.8.0")),
        .package(url: "https://github.com/SnapKit/SnapKit.git", .upToNextMajor(from: "5.0.1"))
    ],
    targets: [
        .target(
            name: "ChatUI",
            dependencies: ["MessageKit", "SnapKit"],
            path: "Sources",
            resources: [
                .process("Resources")
            ],
            swiftSettings: [SwiftSetting.define("IS_SPM")]
        ),
        .testTarget(name: "ChatUITests", dependencies: ["ChatUI"])
    ]
)
