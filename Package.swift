// swift-tools-version:5.0

import PackageDescription

let package = Package(
    name: "IPAPI",
    platforms: [
        .iOS(.v8),
        .macOS(.v10_10),
        .tvOS(.v9),
        .watchOS(.v2)
    ],
    products: [
        .library(name: "IPAPI", targets: ["IPAPI"])
    ],
    targets: [
        .target(
            name: "IPAPI",
            path: "Sources",
            exclude: ["Sources/Info.plist", "Sources/IPAPI.h", "Sources/Info.plist"]
        )
    ],
    swiftLanguageVersions: [.v5]
)
