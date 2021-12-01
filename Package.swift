// swift-tools-version:5.5
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "BraintreeVisaCheckout",
    platforms: [.iOS(.v12)],
    products: [
        .library(
            name: "BraintreeVisaCheckout",
            targets: ["BraintreeVisaCheckout", "VisaCheckoutSDK"]
        )
    ],
    dependencies: [
        .package(name: "Braintree", url: "https://github.com/braintree/braintree_ios", .upToNextMajor(from: "5.5.0"))
    ],
    targets: [
        // Targets are the basic building blocks of a package. A target can define a module or a test suite.
        // Targets can depend on other targets in this package, and on products in packages this package depends on.
        .target(
            name: "BraintreeVisaCheckout",
            dependencies: [
                .product(name: "BraintreeCore", package: "Braintree")
            ],
            path: "BraintreeVisaCheckout",
            exclude: ["Info.plist"],
            publicHeadersPath: "Public"
        ),
        .binaryTarget(
            name: "VisaCheckoutSDK",
            path: "Frameworks/VisaCheckoutSDK.xcframework"
        ),
    ]
)
