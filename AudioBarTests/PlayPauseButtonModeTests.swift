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

}
