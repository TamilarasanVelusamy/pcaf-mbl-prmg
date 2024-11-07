// swift-tools-version: 5.5
// The swift-tools-version declares the minimum version of Swift required to build this package.
import PackageDescription
let package = Package(
    name: "pcaf-mbl-prmg",
    platforms: [.iOS(.v15)],
    products: [
        // Products define the executables and libraries a package produces, and make them visible to other packages.
        .library(
            name: "pcaf-mbl-prmg",
            targets: ["pcaf-mbl-prmg"]),
    ],
    dependencies: [
        // Dependencies declare other packages that this package depends on.
        // .package(url: /* package url */, from: "1.0.0"),
        .package(url: "https://github.com/marmelroy/Zip.git", from: "2.1.2"),
        .package(path: "./Sources/PepNetworkingPackage")
    ],
    targets: [
        // Targets are the basic building blocks of a package. A target can define a module or a test suite.
        // Targets can depend on other targets in this package, and on products in packages this package depends on.
        .binaryTarget(
            name: "BRLMPrinterKit",
            path: "./Sources/pcaf-mbl-prmg/BRLMPrinterKit.xcframework"),
        .binaryTarget(
            name: "FWUpdateSDK",
            path: "./Sources/pcaf-mbl-prmg/FWUpdateSDK.xcframework"),
        .target(
                name: "pcaf-mbl-prmg",
                dependencies: [.product(name: "PepNetworkingPackage", package: "PepNetworkingPackage"),.product(name: "Zip", package: "Zip")],
                path: "./Sources/pcaf-mbl-prmg",
                resources: [
                    .copy("BRLMPrinterKit.xcframework"),
                    .copy("FWUpdateSDK.xcframework")
                ]
        ),
        .testTarget(
            name: "pcaf-mbl-prmgTests",
            dependencies: ["pcaf-mbl-prmg"]),
    ]
)
