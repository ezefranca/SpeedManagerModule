/// Enumeration representing the authorization status for the speed manager.
public enum SpeedManagerAuthorizationStatus: Sendable, Equatable {
    /// The user has not yet been prompted for location permission.
    case notDetermined

    /// The app is authorized to access location updates required for speed monitoring.
    case authorized

    /// The app is not authorized to access location updates.
    case denied
}
