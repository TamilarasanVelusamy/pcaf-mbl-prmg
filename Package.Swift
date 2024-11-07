// swift-tools-version: 5.5
// The swift-tools-version declares the minimum version of Swift required to build this package.
import PackageDescription
let package = Package(
    name: "pcaf-mbl-prmg",
    platforms: [.iOS(.v15)],
    products: [
        .library(
            name: "pcaf-mbl-prmg",
            targets: ["pcaf-mbl-prmg"]),
    ],
    dependencies: [
        .package(url: "https://github.com/marmelroy/Zip.git", from: "2.1.2"),
        .package(path: "./Sources/PepNetworkingPackage")
    ],
    targets: [
        .binaryTarget(
            name: "BRLMPrinterKit",
            path: "./Sources/BRLMPrinterKit.xcframework"),
        .binaryTarget(
            name: "FWUpdateSDK",
            path: "./Sources/FWUpdateSDK.xcframework"),
        .binaryTarget(
            name: "DEXUpgradeSDK",
            path: "./Sources/frameworkDEXUpgradeSDK.xcframework"),
        .target(
                name: "pcaf-mbl-prmg",
                dependencies: ["BRLMPrinterKit","FWUpdateSDK","DEXUpgradeSDK",.product(name: "PepNetworkingPackage", package: "PepNetworkingPackage"),.product(name: "Zip", package: "Zip")]
        ),
        .testTarget(
            name: "pcaf-mbl-prmgTests",
            dependencies: ["pcaf-mbl-prmg"]),
    ]
)
