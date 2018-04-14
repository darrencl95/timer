import XCTest
@testable import Timer

class AppDelegateTests: XCTestCase {
    func testInit() {
        let delegate = AppDelegate.init()
        XCTAssertNotNil(delegate)
    }
}
