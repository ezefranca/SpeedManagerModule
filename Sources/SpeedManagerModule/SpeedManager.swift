import Foundation
import CoreLocation

/// A class that manages the monitoring and updating of speed using CoreLocation.
public class SpeedManager: NSObject, ObservableObject, SpeedManagerTrigger {
    
    // MARK: - Properties
    
    /// The CoreLocation manager used to get location updates.
    private let locationManager = CLLocationManager()
    
    /// The unit of speed to be used.
    private var speedUnit: SpeedManagerUnit
    
    /// The trigger for starting speed updates.
    private var trigger: SpeedManagerTrigger?
    
    /// Indicates whether background location updates are allowed.
    private var allowsBackgroundLocationUpdates: Bool
    
    /// The delegate to receive updates from the SpeedManager.
    public weak var delegate: SpeedManagerDelegate?
    
    /// The current authorization status for location services.
    @Published public private(set) var authorizationStatus: SpeedManagerAuthorizationStatus = .notDetermined {
        didSet {
            DispatchQueue.main.async {
                self.delegate?.speedManager(self, didUpdateAuthorizationStatus: self.authorizationStatus)
            }
        }
    }
    
    /// The current speed.
    @Published public var speed: Double = 0 {
        didSet {
            DispatchQueue.main.async {
                self.delegate?.speedManager(self, didUpdateSpeed: self.speed, speedAccuracy: self.speedAccuracy)
            }
        }
    }
    
    /// The accuracy of the current speed.
    @Published public private(set) var speedAccuracy: Double = 0

    // MARK: - Initializer
    
    /// Initializes a new SpeedManager.
    /// - Parameters:
    ///   - speedUnit: The unit of speed measurement.
    ///   - trigger: An optional trigger for starting speed updates. If nil, the SpeedManager will trigger itself.
    ///   - allowsBackgroundLocationUpdates: A Boolean value indicating whether background location updates are allowed.
    public init(speedUnit: SpeedManagerUnit,
                trigger: SpeedManagerTrigger? = nil,
                allowsBackgroundLocationUpdates: Bool = false) {
        
        self.speedUnit = speedUnit
        self.allowsBackgroundLocationUpdates = allowsBackgroundLocationUpdates
        super.init()
        self.trigger = trigger ?? self
       
        self.locationManager.delegate = self
        self.locationManager.desiredAccuracy = kCLLocationAccuracyBest
        self.locationManager.distanceFilter = kCLHeadingFilterNone
        
        self.locationManager.requestAlwaysAuthorization()
    }
    
    // MARK: - Public Methods
    
    /// Starts updating the speed.
    public func startUpdatingSpeed() {
        trigger?.startMonitoringSpeed()
    }
    
    /// Starts monitoring the speed.
    public func startMonitoringSpeed() {
        switch authorizationStatus {
        case .authorized:
            if allowsBackgroundLocationUpdates {
                locationManager.allowsBackgroundLocationUpdates = true
            }
            locationManager.startUpdatingLocation()
        case .notDetermined:
            locationManager.requestAlwaysAuthorization()
        case .denied:
            DispatchQueue.main.async {
                self.delegate?.speedManagerDidFailWithLocationServicesUnavailable(self)
            }
        }
    }
}

// MARK: - CLLocationManagerDelegate

extension SpeedManager: CLLocationManagerDelegate {
    
    /// Called when the authorization status changes.
    /// - Parameter manager: The location manager reporting the change.
    public func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
        switch manager.authorizationStatus {
        case .authorizedWhenInUse, .authorizedAlways:
            authorizationStatus = .authorized
            locationManager.requestLocation()
        case .notDetermined:
            authorizationStatus = .notDetermined
            manager.requestWhenInUseAuthorization()
        default:
            authorizationStatus = .denied
        }
        
        startMonitoringSpeed()
    }
    
    /// Called when new location data is available.
    /// - Parameters:
    ///   - manager: The location manager providing the data.
    ///   - locations: An array of new location data objects.
    public func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let lastLocation = locations.last else { return }
        
        let currentSpeed = lastLocation.speed
        speed = currentSpeed >= 0 ? currentSpeed * speedUnit.rawValue : .nan
        speedAccuracy = lastLocation.speedAccuracy
        
        locationManager.requestLocation()
    }
    
    /// Called when the location manager encounters an error.
    /// - Parameters:
    ///   - manager: The location manager reporting the error.
    ///   - error: The error encountered by the location manager.
    public func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        DispatchQueue.main.async {
            self.delegate?.speedManager(self, didFailWithError: error)
        }
    }
}
