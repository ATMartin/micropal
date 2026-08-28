// swift-tools-version:5.9
import PackageDescription

let package = Package(
    name: "MicroduckDesktop",
    platforms: [.macOS(.v13)],
    targets: [
        .executableTarget(
            name: "MicroduckDesktop",
            path: "Sources/MicroduckDesktop"
        )
    ]
)
