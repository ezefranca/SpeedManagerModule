import Foundation
import CoreLocation

public class SpeedManager : NSObject, ObservableObject {
    
    // MARK: Private
    private let locationManager = CLLocationManager()
    private var speedUnit: SpeedManagerUnit
    
    // MARK: Public
    public var delegate: SpeedManagerDelegate?
   
    @Published public var authorizationStatus: SpeedManagerAuthorizationStatus = .notDetermined
    @Published public var speed: Double = 0
    
    private var isRequestingLocation = false
    
    init(_ speedUnit: SpeedManagerUnit) {
        
        self.speedUnit = speedUnit
        self.delegate = nil
        super.init()
        
        self.locationManager.delegate = self
        self.locationManager.desiredAccuracy = kCLLocationAccuracyBest
        self.locationManager.distanceFilter = kCLHeadingFilterNone
        
        self.locationManager.requestAlwaysAuthorization()
    }
    
    func startUpdatingSpeed() {
        self.startMonitoringSpeed()
    }
    
    private func startMonitoringSpeed() {
        
        switch self.authorizationStatus {
            
        case .authorized:
            self.locationManager.allowsBackgroundLocationUpdates = true
            self.locationManager.startUpdatingLocation()
        case .notDetermined:
            self.locationManager.requestAlwaysAuthorization()
        case .denied:
            fatalError("No location services available")
        }
    }
}

// MARK: CLLocationManagerDelegate methods

extension SpeedManager: CLLocationManagerDelegate {
    
    public func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
        switch manager.authorizationStatus {
            
        case .authorizedWhenInUse,
                .authorizedAlways:
            authorizationStatus = .authorized
            locationManager.requestLocation()
            break
            
        case .notDetermined:
            authorizationStatus = .notDetermined
            manager.requestWhenInUseAuthorization()
            break
            
        default:
            authorizationStatus = .denied
        }
        
        self.startMonitoringSpeed()
    }
    
    public func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        
        let currentSpeed = locations.last?.speed ?? -1.0
        let calculatedSpeed = currentSpeed * self.speedUnit.rawValue
        self.speed = calculatedSpeed
        self.delegate?.speedManager(self, didUpdateSpeed: calculatedSpeed)
        
        self.locationManager.requestLocation()
    }
    
    public func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        self.delegate?.speedManager(self, didFailWithError: error)
    }
}
