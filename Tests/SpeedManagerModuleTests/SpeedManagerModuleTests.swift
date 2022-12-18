import XCTest
@testable import SpeedManagerModule

final class SpeedManagerModuleTests: XCTestCase {
    func testExample() throws {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct
        // results.
        XCTAssertEqual(SpeedManager(.kilometersPerHour).authorizationStatus, .notDetermined)
    }
}
