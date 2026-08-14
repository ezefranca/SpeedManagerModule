[![Swift 6](https://img.shields.io/badge/Swift-6.0-orange.svg)](https://swift.org)
[![Swift Package Manager](https://img.shields.io/badge/SPM-compatible-4BC51D.svg)](https://github.com/apple/swift-package-manager)
[![CI](https://github.com/ezefranca/SpeedManagerModule/actions/workflows/swift.yml/badge.svg)](https://github.com/ezefranca/SpeedManagerModule/actions/workflows/swift.yml)
[![Swift Package Index](https://img.shields.io/badge/Swift_Package_Index-available-0A84FF)](https://swiftpackageindex.com/ezefranca/SpeedManagerModule)
[![SPI Platforms](https://img.shields.io/endpoint?url=https%3A%2F%2Fswiftpackageindex.com%2Fapi%2Fpackages%2Fezefranca%2FSpeedManagerModule%2Fbadge%3Ftype%3Dplatforms)](https://swiftpackageindex.com/ezefranca/SpeedManagerModule)
[![Swift Versions](https://img.shields.io/endpoint?url=https%3A%2F%2Fswiftpackageindex.com%2Fapi%2Fpackages%2Fezefranca%2FSpeedManagerModule%2Fbadge%3Ftype%3Dswift-versions)](https://swiftpackageindex.com/ezefranca/SpeedManagerModule)
[![SPI Documentation](https://img.shields.io/badge/Documentation-SPI%20DocC-blue)](https://swiftpackageindex.com/ezefranca/SpeedManagerModule/documentation/speedmanagermodule)
[![License](https://img.shields.io/badge/License-MIT-blue.svg)](LICENSE)

# SpeedManagerModule

SpeedManagerModule is a Swift package that reads speed from `CLLocationManager` and exposes it through a delegate API and observable state.

# Demo

https://github.com/user-attachments/assets/fbee0a69-a993-4de2-aebb-9459533b0800

> [!NOTE]
> The Demo UI was created using [LidorFadida](https://github.com/LidorFadida/) package [SpeedometerSwiftUI](https://github.com/LidorFadida/SpeedometerSwiftUI)

## Compatibility

- Swift: **6.0+**
- Platforms: **iOS 15+**, **watchOS 8+**, **macOS 12+**
- Concurrency model: public APIs are **main-actor isolated** and built for Swift 6 strict concurrency checking.

## Installation

```swift
dependencies: [
    .package(url: "https://github.com/ezefranca/SpeedManagerModule.git", from: "2.0.0")
]
```

## Usage

### SwiftUI

```swift
import SwiftUI
import SpeedManagerModule

struct ContentView: View {
    @StateObject private var speedManager = SpeedManager(speedUnit: .kilometersPerHour)

    var body: some View {
        VStack {
            switch speedManager.authorizationStatus {
            case .authorized:
                Text("Current speed: \(speedManager.speed)")
            case .notDetermined, .denied:
                Text("Waiting for authorization")
            }
        }
        .task {
            speedManager.startUpdatingSpeed()
        }
    }
}
```

### Delegate-based integration

```swift
import UIKit
import SpeedManagerModule

@MainActor
final class SpeedViewController: UIViewController {
    private let speedManager = SpeedManager(speedUnit: .kilometersPerHour)

    override func viewDidLoad() {
        super.viewDidLoad()
        speedManager.delegate = self
        speedManager.startUpdatingSpeed()
    }
}

extension SpeedViewController: SpeedManagerDelegate {
    func speedManager(_ speedManager: SpeedManager, didUpdateSpeed speed: Double, speedAccuracy: Double) {}
    func speedManager(_ speedManager: SpeedManager, didFailWithError error: Error) {}
    func speedManager(_ speedManager: SpeedManager, didUpdateAuthorizationStatus status: SpeedManagerAuthorizationStatus) {}
    func speedManagerDidFailWithLocationServicesUnavailable(_ speedManager: SpeedManager) {}
}
```

## Location permissions

Add the required location usage descriptions in your app `Info.plist`:

```xml
<key>NSLocationAlwaysAndWhenInUseUsageDescription</key>
<string>Explain why the app needs location in background.</string>
<key>NSLocationWhenInUseUsageDescription</key>
<string>Explain why the app needs location while in use.</string>
```

For background speed monitoring, enable:

- `UIBackgroundModes` with the `location` value
- `allowsBackgroundLocationUpdates` when creating `SpeedManager`

## Testing

Run package tests:

```bash
swift test
```

## Documentation

- API documentation is generated from DocC-compatible symbol comments.
- Hosted docs: https://swiftpackageindex.com/ezefranca/SpeedManagerModule/documentation/speedmanagermodule

## Release information

- Current planned release for this migration: **v2.0.0**
- See `CHANGELOG.md` for migration notes and breaking changes.
