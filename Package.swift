// swift-tools-version: 6.0
import PackageDescription

let package = Package(
    name: "SudokuApp",
    platforms: [
        .iOS(.v17),
        .macOS(.v13)
    ],
    products: [
        .executable(name: "SudokuApp", targets: ["SudokuApp"])
    ],
    targets: [
        .executableTarget(
            name: "SudokuApp",
            path: ".",
            exclude: [
                ".git",
                "README.md",
                "Package.swift",
                "Tests"
            ],
            sources: [
                "App",
                "Views",
                "Models",
                "Services",
                "Persistence",
                "Utilities"
            ]
        ),
        .testTarget(
            name: "SudokuAppTests",
            dependencies: ["SudokuApp"],
            path: "Tests"
        )
    ]
)
