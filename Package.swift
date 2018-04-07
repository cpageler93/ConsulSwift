// swift-tools-version:4.0
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "ConsulSwift",
    products: [
        .library(name: "ConsulSwift", targets: ["ConsulSwift"])
    ],
    dependencies: [
        .package(url: "https://github.com/cpageler93/quack", from: "1.1.1")
    ],
    targets: [
        .target(name: "ConsulSwift", dependencies: ["Quack", "QuackLinux", "QuackBase"]),
        .testTarget(name: "ConsulSwiftTests", dependencies: ["ConsulSwift"])
    ]
)