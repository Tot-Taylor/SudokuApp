// swift-tools-version: 6.0
import PackageDescription

let package = Package(
    name: "SudokuApp",
    platforms: [
        .iOS(.v17),
        .macOS(.v13)
    ],
    products: [
        .library(name: "SudokuAppCore", targets: ["SudokuAppCore"])
    ],
    targets: [
        .target(
            name: "SudokuAppCore",
            path: ".",
            exclude: [
                ".git",
                "Views",
                "App",
                "README.md",
                "Package.swift",
                "Tests"
            ],
            sources: [
                "Models",
                "Services",
                "Persistence",
                "Utilities"
            ]
        ),
        .testTarget(
            name: "SudokuAppCoreTests",
            dependencies: ["SudokuAppCore"],
            path: "Tests"
        )
    ]
)
