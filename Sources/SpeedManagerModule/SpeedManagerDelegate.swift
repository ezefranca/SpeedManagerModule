import Foundation

/// Protocol defining the delegate methods for the SpeedManager.
public protocol SpeedManagerDelegate: AnyObject {
    /// Called when the speed manager updates the speed.
    func speedManager(_ speedManager: SpeedManager, didUpdateSpeed speed: Double, speedAccuracy: Double)
    
    /// Called when the speed manager encounters an error.
    func speedManager(_ speedManager: SpeedManager, didFailWithError error: Error)
    
    /// Called when the authorization status changes.
    func speedManager(_ speedManager: SpeedManager, didUpdateAuthorizationStatus status: SpeedManagerAuthorizationStatus)
    
    /// Called when location services are not available.
    func speedManagerDidFailWithLocationServicesUnavailable(_ speedManager: SpeedManager)
}
