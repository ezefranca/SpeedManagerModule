import Foundation

public protocol SpeedManagerDelegate {
    func speedManager(_ manager: SpeedManager, didUpdateSpeed speed: Double, speedAccuracy: Double)
    func speedManager(_ manager: SpeedManager, didFailWithError error: Error)
}
