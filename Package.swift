// swift-tools-version:5.5

import PackageDescription

let package = Package(
    name: "CoreImageView",
    platforms: [
        .macOS(.v11),
        .iOS(.v15)
    ],
    products: [
        .library(name: "CoreImageView", targets: ["CoreImageView"])
    ],
    targets: [
        .target(name: "CoreImageView")
    ]
)
