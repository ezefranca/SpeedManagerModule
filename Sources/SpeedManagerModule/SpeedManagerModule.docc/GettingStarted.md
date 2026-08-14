# Getting Started

Set up `SpeedManagerModule` and start receiving speed updates.

## Add the package dependency

Add `SpeedManagerModule` to your `Package.swift` dependencies:

```swift
.package(url: "https://github.com/ezefranca/SpeedManagerModule.git", from: "1.0.0")
```

Then add `SpeedManagerModule` to your target dependencies.

## Create a speed manager

Create a ``SpeedManager`` with the speed unit you want to present in your UI:

```swift
let speedManager = SpeedManager(speedUnit: .kilometersPerHour)
```

## Start monitoring

Call ``SpeedManager/startUpdatingSpeed()`` to start the authorization and monitoring flow.

## Receive updates

Choose one of these integration styles:

- Observe `@Published` properties (`speed`, `authorizationStatus`, and `speedAccuracy`) from SwiftUI.
- Implement ``SpeedManagerDelegate`` for delegate-driven integration.
