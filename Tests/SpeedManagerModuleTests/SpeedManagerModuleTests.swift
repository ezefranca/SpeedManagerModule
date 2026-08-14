import XCTest
@testable import SpeedManagerModule

final class SpeedManagerModuleTests: XCTestCase {
    func testStartUpdatingSpeedDelegatesToTrigger() async {
        let callCount = await MainActor.run { () -> Int in
            let trigger = TriggerMock()
            let manager = SpeedManager(speedUnit: .kilometersPerHour, trigger: trigger)
            manager.startUpdatingSpeed()
            return trigger.startMonitoringCalls
        }

        XCTAssertEqual(callCount, 1)
    }

    func testSpeedUpdateNotifiesDelegateWithAccuracy() async {
        let event = await MainActor.run { () -> (Double, Double)? in
            let trigger = TriggerMock()
            let delegate = SpeedManagerDelegateMock()
            let manager = SpeedManager(speedUnit: .kilometersPerHour, trigger: trigger)
            manager.delegate = delegate
            manager.speed = 12.2
            guard let event = delegate.speedEvents.first else { return nil }
            return (event.speed, event.speedAccuracy)
        }

        XCTAssertEqual(event?.0, 12.2)
        XCTAssertEqual(event?.1, 0)
    }

    func testAuthorizationStatusIsDeniedOnPlatformsWithoutCoreLocation() async throws {
#if canImport(CoreLocation)
        throw XCTSkip("This assertion is only deterministic on platforms without CoreLocation.")
#else
        let status = await MainActor.run { () -> SpeedManagerAuthorizationStatus in
            let manager = SpeedManager(speedUnit: .kilometersPerHour)
            return manager.authorizationStatus
        }
        XCTAssertEqual(status, .denied)
#endif
    }

    func testDeniedMonitoringNotifiesDelegateOnPlatformsWithoutCoreLocation() async throws {
#if canImport(CoreLocation)
        throw XCTSkip("This assertion is only deterministic on platforms without CoreLocation.")
#else
        let unavailableCalls = await MainActor.run { () -> Int in
            let delegate = SpeedManagerDelegateMock()
            let manager = SpeedManager(speedUnit: .kilometersPerHour)
            manager.delegate = delegate
            manager.startMonitoringSpeed()
            return delegate.locationUnavailableCalls
        }
        XCTAssertEqual(unavailableCalls, 1)
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
