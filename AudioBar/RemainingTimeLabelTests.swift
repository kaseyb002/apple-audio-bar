import XCTest
@testable import AudioBar

class RemainingTimeLabelTests: XCTestCase {

    // MARK: System under test

    let remainingTimeLabel = RemainingTimeLabel()

    // MARK: Main

    func testType() {
        XCTAssert(remainingTimeLabel, directlyInheritsFrom: UILabel.self)
    }

    // MARK: Updating remaining time

    func testRemainingTimeType() {
        XCTAssert(remainingTimeLabel.remainingTime, is: Optional<TimeInterval>.self)
    }

    func testRemainingTimeLabelText1() {
        let remainingTimeText = "A"
        let remainingTimeFormatterStub = RemainingTimeFormatterStub(cannedOutput: remainingTimeText)
        remainingTimeLabel.remainingTimeFormatter = remainingTimeFormatterStub
        remainingTimeLabel.remainingTime = 0
        XCTAssertEqual(remainingTimeLabel.text, remainingTimeText)
    }

    func testRemainingTimeLabelText2() {
        let remainingTimeText = "B"
        let remainingTimeFormatterStub = RemainingTimeFormatterStub(cannedOutput: remainingTimeText)
        remainingTimeLabel.remainingTimeFormatter = remainingTimeFormatterStub
        remainingTimeLabel.remainingTime = 0
        XCTAssertEqual(remainingTimeLabel.text, remainingTimeText)
    }

    func testRemainingTimeLabelTextReset() {
        remainingTimeLabel.text = "A"
        remainingTimeLabel.remainingTime = nil
        XCTAssertNil(remainingTimeLabel.text)
    }

    // MARK: Formatting remaining time

    func testRemainingTimeFormatterType() {
        XCTAssert(remainingTimeLabel.remainingTimeFormatter as Any is RemainingTimeFormatting)
    }

    func testRemainingTimeFormatterIdentity() {
        XCTAssert(remainingTimeLabel.remainingTimeFormatter === remainingTimeLabel.remainingTimeFormatter)
    }

    func testRemainingTimeFormatterAllowedUnits() {
        let remainingTimeFormatter = remainingTimeLabel.remainingTimeFormatter as! DateComponentsFormatter
        XCTAssertEqual(remainingTimeFormatter.allowedUnits, [.minute, .second])
    }

    func testRemainingTimeFormatterInput1() {
        let spy = RemainingTimeFormatterSpy()
        remainingTimeLabel.remainingTimeFormatter = spy
        remainingTimeLabel.remainingTime = 1
        XCTAssertEqual(spy.capturedTimeIntervals, [1])
    }

    func testRemainingTimeFormatterInput2() {
        let spy = RemainingTimeFormatterSpy()
        remainingTimeLabel.remainingTimeFormatter = spy
        remainingTimeLabel.remainingTime = 2
        XCTAssertEqual(spy.capturedTimeIntervals, [2])
    }
    
}

private class RemainingTimeFormatterSpy: RemainingTimeFormatting {

    var capturedTimeIntervals: [TimeInterval] = []

    func string(from timeInterval: TimeInterval) -> String? {
        capturedTimeIntervals.append(timeInterval)
        return nil
    }

}

private class RemainingTimeFormatterStub: RemainingTimeFormatting {

    let cannedOutput: String?

    init(cannedOutput: String?) {
        self.cannedOutput = cannedOutput
    }

    func string(from timeInterval: TimeInterval) -> String? {
        return cannedOutput
    }
    
}
