// swift-tools-version:3.1

import PackageDescription

let package = Package(
    name: "ConsulSwift",
    dependencies: [
        .Package(url: "https://github.com/cpageler93/Quack.git", majorVersion: 1)
    ]
)
