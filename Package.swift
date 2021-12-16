// swift-tools-version:5.5

import PackageDescription

let package = Package(
    name: "CoreImageView",
    products: [
        .library(name: "CoreImageView", targets: ["CoreImageView"])
    ],
    targets: [
        .target(name: "CoreImageView")
    ]
)
