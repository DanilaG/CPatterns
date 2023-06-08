// swift-tools-version:5.6

import PackageDescription

let package = Package(
    name: "test",
    platforms: [
        .macOS(.v10_15),
    ],
    products: [
    ],
    dependencies: [
    ],
    targets: [
        // MARK: Executables

        .target(
            name: "Doji",
            path: "Doji/PatternDetector"
        ),

        // MARK: Tests

        .testTarget(
            name: "DojiTests",
            dependencies: [
                "Doji",
            ],
            path: "DojiTests",
            resources: [
                .process("sber.csv"),
            ]
        ),
    ]
)
