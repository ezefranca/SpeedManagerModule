import Foundation

protocol SpeedManagerDelegate {
    func speedManager(_ manager: SpeedManager, didUpdateSpeed speed: Double)
    func speedManager(_ manager: SpeedManager, didFailWithError error: Error)
}
