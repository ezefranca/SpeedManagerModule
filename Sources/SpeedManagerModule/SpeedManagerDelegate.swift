import Foundation

/// Protocol defining the delegate methods for the SpeedManager.
/// All callbacks are delivered on the main actor.
@MainActor
public protocol SpeedManagerDelegate: AnyObject {
    /// Called when the speed manager updates the speed.
    /// - Parameters:
    ///   - speedManager: The manager emitting the update.
    ///   - speed: The current speed converted to the configured unit.
    ///   - speedAccuracy: The accuracy (in meters per second) reported by Core Location.
    func speedManager(_ speedManager: SpeedManager, didUpdateSpeed speed: Double, speedAccuracy: Double)
    
    /// Called when the speed manager encounters an error.
    /// - Parameters:
    ///   - speedManager: The manager emitting the failure.
    ///   - error: The underlying location error.
    func speedManager(_ speedManager: SpeedManager, didFailWithError error: Error)
    
    /// Called when the authorization status changes.
    /// - Parameters:
    ///   - speedManager: The manager emitting the status update.
    ///   - status: The latest authorization status used by ``SpeedManager``.
    func speedManager(_ speedManager: SpeedManager, didUpdateAuthorizationStatus status: SpeedManagerAuthorizationStatus)
    
    /// Called when location services are not available.
    /// - Parameter speedManager: The manager that cannot monitor speed.
    func speedManagerDidFailWithLocationServicesUnavailable(_ speedManager: SpeedManager)
}
