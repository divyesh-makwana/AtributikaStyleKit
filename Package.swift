// swift-tools-version: 5.7
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "AtributikaStyleKit",
    products: [
        // Products define the executables and libraries a package produces, and make them visible to other packages.
        .library(
            name: "AtributikaStyleKit",
            targets: ["AtributikaStyleKit"]),
    ],
    dependencies: [
        // Dependencies declare other packages that this package depends on.
         .package(url: "https://github.com/psharanda/Atributika.git", from: "4.10.1"),
    ],
    targets: [
        // Targets are the basic building blocks of a package. A target can define a module or a test suite.
        // Targets can depend on other targets in this package, and on products in packages this package depends on.
        .target(
            name: "AtributikaStyleKit",
            dependencies: ["Atributika"]),
        .testTarget(
            name: "AtributikaStyleKitTests",
            dependencies: ["AtributikaStyleKit"]),
    ]
)
