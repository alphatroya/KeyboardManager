// swift-tools-version:5.0
import PackageDescription

let package = Package(
    name: "KeyboardManager",
    platforms: [.iOS(.v9)],
    products: [
        .library(name: "KeyboardManager", targets: ["KeyboardManager"]),
    ],
    targets: [
        .target(
            name: "KeyboardManager",
            path: "Sources"
        ),
    ]
)
