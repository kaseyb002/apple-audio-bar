import XCTest
@testable import AudioBar

class DefaultRemainingTimeWidgetTests: XCTestCase {

    // MARK: System under test

    let remainingTimeWidget = DefaultRemainingTimeWidget()

    // MARK: Main

    func testInterface() {
        XCTAssertTrue(remainingTimeWidget as Any is RemainingTimeWidget)
    }

    // MARK: Label

    func testLabelType() {
        XCTAssertTrue(remainingTimeWidget.label as Any is UILabel)
    }

    // MARK: Time formatting input

    func testTimeFormattingInput1() { testTimeFormattingInput(withRemainingTime: 1) }
    func testTimeFormattingInput2() { testTimeFormattingInput(withRemainingTime: 2) }

    func testTimeFormattingInput(withRemainingTime remainingTime: TimeInterval, file: StaticString = #file, line: UInt = #line) {
        class TimeFormattingMock: TimeFormattingDouble {
            var timeIntervals: [TimeInterval] = []
            func string(from timeInterval: TimeInterval) -> String? {
                timeIntervals.append(timeInterval)
                return nil
            }
        }
        let timeFormattingMock = TimeFormattingMock()
        remainingTimeWidget.timeFormatting = timeFormattingMock
        remainingTimeWidget.showRemainingTime(remainingTime)
        XCTAssertEqual(timeFormattingMock.timeIntervals, [remainingTime], file: file, line: line)
    }

    // MARK: Time formatting output

    func testTimeFormattingOutput1() { testTimeFormattingOutput(withFormattedTime: "A") }
    func testTimeFormattingOutput2() { testTimeFormattingOutput(withFormattedTime: "B") }

    func testTimeFormattingOutput(withFormattedTime formattedTime: String, file: StaticString = #file, line: UInt = #line) {
        class TimeFormattingStub: TimeFormattingDouble {
            let formattedTime: String
            init(formattedTime: String) { self.formattedTime = formattedTime }
            func string(from timeInterval: TimeInterval) -> String? { return formattedTime }
        }
        remainingTimeWidget.timeFormatting = TimeFormattingStub(formattedTime: formattedTime)
        remainingTimeWidget.showRemainingTime(0)
        XCTAssertEqual(remainingTimeWidget.label.text, "-" + formattedTime, file: file, line: line)
    }

    func testTimeFormattingOutputNil() {
        class TimeFormattingStub: TimeFormattingDouble {
            func string(from timeInterval: TimeInterval) -> String? { return nil }
        }
        remainingTimeWidget.label.text = "A"
        remainingTimeWidget.timeFormatting = TimeFormattingStub()
        remainingTimeWidget.showRemainingTime(0)
        XCTAssertNil(remainingTimeWidget.label.text)
    }

    // MARK: No remaining time

    func testRemainingTimeNone() {
        remainingTimeWidget.label.text = "A"
        remainingTimeWidget.showRemainingTime(nil)
        XCTAssertNil(remainingTimeWidget.label.text)
    }

    // MARK: Time formatting defaults

    func testTimeFormattingType() {
        XCTAssert(remainingTimeWidget.timeFormatting as Any is TimeFormatting)
    }

    func testTimeFormattingIsConstant() {
        XCTAssertConstant(remainingTimeWidget.timeFormatting)
    }

    func testTimeFormattingAllowedUnits() {
        let timeFormatting = remainingTimeWidget.timeFormatting as? DateComponentsFormatter
        XCTAssertEqual(timeFormatting?.allowedUnits, [.minute, .second])
    }

}
