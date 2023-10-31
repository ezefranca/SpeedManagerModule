import XCTest
@testable import SpeedManagerModule

final class SpeedManagerModuleTests: XCTestCase {
    
    var manager: SpeedManager?
    
    func test_speed() throws {
        let mockDelegate = SpeedManagerDelegateMock(testCase: self)
        manager = SpeedManager(.kilometersPerHour, trigger: self)
        manager?.delegate = mockDelegate
        
        mockDelegate.expectSpeed()
        manager?.startUpdatingSpeed()
        
        waitForExpectations(timeout: 1)
        
        let result = try XCTUnwrap(mockDelegate.speed)
        XCTAssertEqual(result, 12.2)
    }
}

extension SpeedManagerModuleTests: SpeedManagerTrigger {
    func startMonitoringSpeed() {
        guard let manager = manager else { return }
        self.manager?.delegate?.speedManager(manager,
                                             didUpdateSpeed: 12.2, speedAccuracy: 1)
    }
    
    func startUpdatingSpeed() {
        self.startMonitoringSpeed()
    }
}

class SpeedManagerDelegateMock: SpeedManagerDelegate {    
   
    var speed: Double?
    private var expectation: XCTestExpectation?
    private let testCase: XCTestCase
    
    var didUpdateSpeed: Bool = false
    var didFailWithError: Bool = false
    
    func speedManager(_ manager: SpeedManagerModule.SpeedManager, didUpdateSpeed speed: Double, speedAccuracy: Double) {
        didUpdateSpeed = true
        
        if expectation != nil { self.speed = speed }
        expectation?.fulfill()
        expectation = nil
    }
    
    func speedManager(_ manager: SpeedManagerModule.SpeedManager, didFailWithError error: Error) {
        didFailWithError = true
    }
    
    init(testCase: XCTestCase) {
        self.testCase = testCase
    }

    func expectSpeed() {
        expectation = testCase.expectation(description: "Expect speed")
    }
}


