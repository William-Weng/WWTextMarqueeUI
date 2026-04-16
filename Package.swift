// swift-tools-version: 6.1
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "WWTextMarqueeUI",
    platforms: [
        .iOS(.v17)
    ],
    products: [
        .library(name: "WWTextMarqueeUI", targets: ["WWTextMarqueeUI"]),
    ],
    dependencies: [
        .package(url: "https://github.com/William-Weng/WWTextRasterizer", .upToNextMinor(from: "1.2.0")),
    ],
    targets: [
        .target(
            name: "WWTextMarqueeUI",
            dependencies: [.product(name: "WWTextRasterizer", package: "WWTextRasterizer")],
            resources: [.copy("Privacy")]
        ),
    ],
    swiftLanguageModes: [
        .v6
    ]
)
