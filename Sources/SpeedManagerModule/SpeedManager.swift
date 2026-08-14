import Foundation
#if canImport(Combine)
import Combine
#endif
#if canImport(CoreLocation)
import CoreLocation
#endif

/// A main-actor isolated manager that monitors and publishes user speed updates.
///
/// - Important: On platforms where `CoreLocation` is unavailable, authorization is set to `.denied`
///   and monitoring reports location services as unavailable.
@MainActor
public final class SpeedManager: NSObject, SpeedManagerTrigger
#if canImport(Combine)
,
ObservableObject
#endif
{
    /// The unit of speed to be used.
    private let speedUnit: SpeedManagerUnit

    /// The trigger for starting speed updates.
    private var trigger: SpeedManagerTrigger?

    /// Indicates whether background location updates are allowed.
    private let allowsBackgroundLocationUpdates: Bool

    /// The delegate to receive updates from the `SpeedManager`.
    public weak var delegate: (any SpeedManagerDelegate)?

#if canImport(Combine)
    /// The current authorization status for location services.
    @Published public private(set) var authorizationStatus: SpeedManagerAuthorizationStatus = .notDetermined {
        didSet {
            delegate?.speedManager(self, didUpdateAuthorizationStatus: authorizationStatus)
        }
    }

    /// The current speed.
    @Published public var speed: Double = 0 {
        didSet {
            delegate?.speedManager(self, didUpdateSpeed: speed, speedAccuracy: speedAccuracy)
        }
    }

    /// The accuracy of the current speed.
    @Published public private(set) var speedAccuracy: Double = 0
#else
    /// The current authorization status for location services.
    public private(set) var authorizationStatus: SpeedManagerAuthorizationStatus = .notDetermined {
        didSet {
            delegate?.speedManager(self, didUpdateAuthorizationStatus: authorizationStatus)
        }
    }

    /// The current speed.
    public var speed: Double = 0 {
        didSet {
            delegate?.speedManager(self, didUpdateSpeed: speed, speedAccuracy: speedAccuracy)
        }
    }

    /// The accuracy of the current speed.
    public private(set) var speedAccuracy: Double = 0
#endif

#if canImport(CoreLocation)
    /// The CoreLocation manager used to get location updates.
    private let locationManager = CLLocationManager()
#endif

    // MARK: - Initializer

    /// Initializes a new SpeedManager.
    /// - Parameters:
    ///   - speedUnit: The unit of speed measurement.
    ///   - trigger: An optional trigger for starting speed updates. If `nil`, the `SpeedManager` will trigger itself.
    ///   - allowsBackgroundLocationUpdates: A Boolean value indicating whether background location updates are allowed.
    public init(speedUnit: SpeedManagerUnit,
                trigger: SpeedManagerTrigger? = nil,
                allowsBackgroundLocationUpdates: Bool = false) {
        self.speedUnit = speedUnit
        self.allowsBackgroundLocationUpdates = allowsBackgroundLocationUpdates
        super.init()
        self.trigger = trigger ?? self

#if canImport(CoreLocation)
        self.locationManager.delegate = self
        self.locationManager.desiredAccuracy = kCLLocationAccuracyBest
        self.locationManager.distanceFilter = kCLHeadingFilterNone
        self.locationManager.requestAlwaysAuthorization()
#else
        self.authorizationStatus = .denied
#endif
    }

    // MARK: - Public Methods

    /// Starts updating the speed.
    public func startUpdatingSpeed() {
        trigger?.startMonitoringSpeed()
    }

    /// Starts monitoring the speed.
    ///
    /// Monitoring requires location authorization and an available CoreLocation runtime.
    public func startMonitoringSpeed() {
        switch authorizationStatus {
        case .authorized:
#if canImport(CoreLocation)
            if allowsBackgroundLocationUpdates {
                locationManager.allowsBackgroundLocationUpdates = true
            }
            locationManager.startUpdatingLocation()
#else
            delegate?.speedManagerDidFailWithLocationServicesUnavailable(self)
#endif
        case .notDetermined:
#if canImport(CoreLocation)
            locationManager.requestAlwaysAuthorization()
#else
            authorizationStatus = .denied
            delegate?.speedManagerDidFailWithLocationServicesUnavailable(self)
#endif
        case .denied:
            delegate?.speedManagerDidFailWithLocationServicesUnavailable(self)
        }
    }
}

// MARK: - CLLocationManagerDelegate

#if canImport(CoreLocation)
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
        delegate?.speedManager(self, didFailWithError: error)
    }
}
#endif
