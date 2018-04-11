// swift-tools-version:4.1

import PackageDescription

let package = Package(
    name: "ConsulSwift",
    products: [
        .library(name: "ConsulSwift", targets: ["ConsulSwift"])
    ],
    dependencies: [
        .package(url: "https://github.com/cpageler93/quack", from: "1.3.1")
    ],
    targets: [
        .target(name: "ConsulSwift", dependencies: ["Quack"]),
        .testTarget(name: "ConsulSwiftTests", dependencies: ["ConsulSwift"])
    ]
)