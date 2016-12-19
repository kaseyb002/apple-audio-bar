import XCTest
@testable import AudioBar

final class PlayPauseButtonModeTests: XCTestCase {

    func testWhenPaused() {
        let model = Model.readyToPlay(.init(isPlaying: false))
        let view = Module.view(for: model)
        XCTAssertEqual(view.playPauseButtonMode, .play)
    }

    func testWhenPlaying() {
        let model = Model.readyToPlay(.init(isPlaying: true))
        let view = Module.view(for: model)
        XCTAssertEqual(view.playPauseButtonMode, .pause)
    }

    func testWithPositiveRemainingTime() {
        let model = Model.readyToPlay(.init(duration: 60, currentTime: 59))
        let view = Module.view(for: model)
        XCTAssertTrue(view.isPlayPauseButtonEnabled)
    }

    func testWithZeroRemainingTime() {
        let model = Model.readyToPlay(.init(duration: 60, currentTime: 60))
        let view = Module.view(for: model)
        XCTAssertFalse(view.isPlayPauseButtonEnabled)
    }

}
