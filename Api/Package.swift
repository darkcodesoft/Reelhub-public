// swift-tools-version:5.8.0
import PackageDescription

let package = Package(
    name: "reelhub-api",
    platforms: [
        .macOS(.v12)
    ],
    dependencies: [
        // 💧 A server-side Swift web framework.
        .package(url: "https://github.com/vapor/vapor.git", from: "4.3.0"),
        .package(url: "https://github.com/vapor/leaf.git", from: "4.0.0"),
        .package(url: "https://github.com/Neo4j-Swift/Neo4j-Swift.git", from: "5.0.0"),
        .package(url: "https://github.com/binarybirds/swift-html", from: "1.2.0"),
        .package(url: "https://github.com/Alamofire/Alamofire.git", from: "5.4.0"),
    ],
    targets: [
        .target(
            name: "App",
            dependencies: [
                .product(name: "Vapor", package: "vapor"),
                .product(name: "Leaf", package: "leaf"),
                .product(name: "Theo", package: "Neo4j-Swift"),
                .product(name: "SwiftHtml", package: "swift-html"),
                .product(name: "Alamofire", package: "Alamofire"),
            ],
            swiftSettings: [
                // Enable better optimizations when building in Release configuration. Despite the use of
                // the `.unsafeFlags` construct required by SwiftPM, this flag is recommended for Release
                // builds. See <https://github.com/swift-server/guides/blob/main/docs/building.md#building-for-production> for details.
                .unsafeFlags(["-cross-module-optimization"], .when(configuration: .release))
            ]
        ),
        .executableTarget(name: "Run", dependencies: [.target(name: "App")]),
        .testTarget(
            name: "AppTests", dependencies: [
            .target(name: "App"),
            .product(name: "XCTVapor", package: "vapor"),
        ])
    ]
)
