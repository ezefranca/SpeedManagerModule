# SwiftUI and Delegate Integration

Use `SpeedManagerModule` with either SwiftUI observation or delegate callbacks.

## SwiftUI observation

`SpeedManager` conforms to `ObservableObject` when Combine is available, so SwiftUI can react to speed changes.

Create and observe the manager in your view model or view:

```swift
@StateObject private var speedManager = SpeedManager(speedUnit: .kilometersPerHour)
```

Read the current values from:

- ``SpeedManager/speed``
- ``SpeedManager/speedAccuracy``
- ``SpeedManager/authorizationStatus``

## Delegate callbacks

For UIKit or imperative integrations, adopt ``SpeedManagerDelegate`` and assign it to ``SpeedManager/delegate``.

Use callbacks for:

- Speed updates via ``SpeedManagerDelegate/speedManager(_:didUpdateSpeed:speedAccuracy:)``
- Authorization changes via ``SpeedManagerDelegate/speedManager(_:didUpdateAuthorizationStatus:)``
- Errors via ``SpeedManagerDelegate/speedManager(_:didFailWithError:)``
- Unavailable services via ``SpeedManagerDelegate/speedManagerDidFailWithLocationServicesUnavailable(_:)``
