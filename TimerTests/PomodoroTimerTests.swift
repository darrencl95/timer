import XCTest

@testable import Timer

class PomodoroTimerTests: XCTestCase {

    override func setUp() {
        super.setUp()
    }
    
    override func tearDown() {
        super.tearDown()
    }

    func testInit() {
        let timer = PomodoroTimer.init()
        XCTAssertEqual(timer.stage, PomodoroTimer.Stage.Work)
    }
}
