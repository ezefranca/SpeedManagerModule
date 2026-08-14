import XCTest
@testable import SpeedManagerModule

@MainActor
final class SpeedManagerModuleTests: XCTestCase {
    func testStartUpdatingSpeedDelegatesToTrigger() {
        let trigger = TriggerMock()
        let manager = SpeedManager(speedUnit: .kilometersPerHour, trigger: trigger)

        manager.startUpdatingSpeed()

        XCTAssertEqual(trigger.startMonitoringCalls, 1)
    }

    func testSpeedUpdateNotifiesDelegateWithAccuracy() {
        let trigger = TriggerMock()
        let delegate = SpeedManagerDelegateMock()
        let manager = SpeedManager(speedUnit: .kilometersPerHour, trigger: trigger)
        manager.delegate = delegate

        manager.speed = 12.2

        XCTAssertEqual(delegate.speedEvents.count, 1)
        XCTAssertEqual(delegate.speedEvents.first?.speed, 12.2)
        XCTAssertEqual(delegate.speedEvents.first?.speedAccuracy, 0)
    }

    func testAuthorizationStatusIsDeniedOnPlatformsWithoutCoreLocation() {
#if canImport(CoreLocation)
        throw XCTSkip("This assertion is only deterministic on platforms without CoreLocation.")
#else
        let manager = SpeedManager(speedUnit: .kilometersPerHour)
        XCTAssertEqual(manager.authorizationStatus, .denied)
#endif
    }

    func testDeniedMonitoringNotifiesDelegateOnPlatformsWithoutCoreLocation() {
#if canImport(CoreLocation)
        throw XCTSkip("This assertion is only deterministic on platforms without CoreLocation.")
#else
        let delegate = SpeedManagerDelegateMock()
        let manager = SpeedManager(speedUnit: .kilometersPerHour)
        manager.delegate = delegate

        manager.startMonitoringSpeed()

        XCTAssertEqual(delegate.locationUnavailableCalls, 1)
#endif
    }

    func testAuthorizationAndUnitAreSendable() {
        assertSendable(SpeedManagerAuthorizationStatus.authorized)
        assertSendable(SpeedManagerUnit.kilometersPerHour)
    }

    private func assertSendable<T: Sendable>(_ value: T) {
        _ = value
    }
}

@MainActor
private final class TriggerMock: SpeedManagerTrigger {
    var startMonitoringCalls = 0

    func startUpdatingSpeed() {}

    func startMonitoringSpeed() {
        startMonitoringCalls += 1
    }
}

@MainActor
private final class SpeedManagerDelegateMock: SpeedManagerDelegate {
    struct SpeedEvent: Equatable {
        let speed: Double
        let speedAccuracy: Double
    }

    var speedEvents: [SpeedEvent] = []
    var didFailWithErrorCalls = 0
    var authorizationUpdates: [SpeedManagerAuthorizationStatus] = []
    var locationUnavailableCalls = 0

    func speedManager(_ speedManager: SpeedManager, didUpdateSpeed speed: Double, speedAccuracy: Double) {
        speedEvents.append(.init(speed: speed, speedAccuracy: speedAccuracy))
    }

    func speedManager(_ speedManager: SpeedManager, didFailWithError error: any Error) {
        didFailWithErrorCalls += 1
    }

    func speedManager(_ speedManager: SpeedManager, didUpdateAuthorizationStatus status: SpeedManagerAuthorizationStatus) {
        authorizationUpdates.append(status)
    }

    func speedManagerDidFailWithLocationServicesUnavailable(_ speedManager: SpeedManager) {
        locationUnavailableCalls += 1
    }
}
