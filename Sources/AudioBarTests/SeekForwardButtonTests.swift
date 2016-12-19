import XCTest
@testable import AudioBar

final class SeekForwardButtonTests: XCTestCase {

    func testWithNoRemainingTime() {
        let model = Model.readyToPlay(.init(currentTime: nil))
        let view = Module.view(for: model)
        XCTAssertFalse(view.isSeekForwardButtonEnabled)
    }

    func testWithPositiveRemainingTime1() {
        let model = Model.readyToPlay(.init(duration: 1, currentTime: 0.99))
        let view = Module.view(for: model)
        XCTAssertTrue(view.isSeekForwardButtonEnabled)
    }

    func testWithPositiveRemainingTime2() {
        let model = Model.readyToPlay(.init(duration: 2, currentTime: 1.99))
        let view = Module.view(for: model)
        XCTAssertTrue(view.isSeekForwardButtonEnabled)
    }

    func testWithZeroRemainingTime1() {
        let model = Model.readyToPlay(.init(duration: 1, currentTime: 1))
        let view = Module.view(for: model)
        XCTAssertFalse(view.isSeekForwardButtonEnabled)
    }

    func testWithZeroRemainingTime2() {
        let model = Model.readyToPlay(.init(duration: 2, currentTime: 2))
        let view = Module.view(for: model)
        XCTAssertFalse(view.isSeekForwardButtonEnabled)
    }
    
}
