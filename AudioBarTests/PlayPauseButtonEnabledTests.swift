import XCTest
@testable import AudioBar

final class PlayPauseButtonEnabledTests: XCTestCase {

    func testWithNoRemainingTime() {
        let model = Model.readyToPlay(.init(currentTime: nil))
        let view = Module.view(for: model)
        XCTAssertTrue(view.isPlayPauseButtonEnabled)
    }

    func testWithZeroRemainingTime() {
        let model = Model.readyToPlay(.init(duration: 60, currentTime: 60))
        let view = Module.view(for: model)
        XCTAssertFalse(view.isPlayPauseButtonEnabled)
    }

    func testWithPositiveRemainingTime1() {
        let model = Model.readyToPlay(.init(duration: 60, currentTime: 59))
        let view = Module.view(for: model)
        XCTAssertTrue(view.isPlayPauseButtonEnabled)
    }

    func testWithPositiveRemainingTime2() {
        let model = Model.readyToPlay(.init(duration: 60, currentTime: 58))
        let view = Module.view(for: model)
        XCTAssertTrue(view.isPlayPauseButtonEnabled)
    }
    
}
