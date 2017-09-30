// swift-tools-version:4.0

import PackageDescription

var dependencies: [Package.Dependency] = [
    .package(url: "https://github.com/cpageler93/Quack.git", .branch("feature/linux"))
]

var consulSwiftDependencies: [Target.Dependency] = [
    .byNameItem(name: "Quack")
]

let package = Package(
    name: "ConsulSwift",
    products: [
        .library(name: "ConsulSwift", targets: ["ConsulSwift"]),
    ],
    dependencies: dependencies,
    targets: [
        .target(name: "ConsulSwift", dependencies: consulSwiftDependencies),
        .testTarget(name: "ConsulSwiftTests", dependencies: ["ConsulSwift"]),
    ]
)