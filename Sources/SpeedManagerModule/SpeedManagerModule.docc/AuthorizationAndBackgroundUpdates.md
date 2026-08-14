# Authorization and Background Updates

Configure location permissions and optional background updates.

## Required Info.plist keys

Apps using this package must provide location usage description keys:

- `NSLocationWhenInUseUsageDescription`
- `NSLocationAlwaysAndWhenInUseUsageDescription` (if background updates are required)

Without these keys, authorization requests will fail at runtime.

## Authorization lifecycle

``SpeedManager`` publishes status updates through:

- ``SpeedManager/authorizationStatus``
- ``SpeedManagerDelegate/speedManager(_:didUpdateAuthorizationStatus:)``

Possible values are represented by ``SpeedManagerAuthorizationStatus``.

## Background monitoring

To support background speed monitoring:

1. Initialize ``SpeedManager`` with `allowsBackgroundLocationUpdates: true`.
2. Enable the `location` background mode in your app target.

If authorization is denied or location services are unavailable, the manager reports this through ``SpeedManagerDelegate/speedManagerDidFailWithLocationServicesUnavailable(_:)``.
