import XCTest
@testable import AudioBar

final class PlaybackTimeTests: XCTestCase {

    func testWithNoCurrentTime() {
        let model = Model.readyToPlay(.init(currentTime: nil))
        let view = Module.view(for: model)
        XCTAssertEqual(view.playbackTime, "")
    }

    func testWithZeroCurrentTime1() {
        let model = Model.readyToPlay(.init(duration: 1, currentTime: 0))
        let view = Module.view(for: model)
        XCTAssertEqual(view.playbackTime, "-0:01")
    }

    func testWithZeroCurrentTime2() {
        let model = Model.readyToPlay(.init(duration: 61, currentTime: 0))
        let view = Module.view(for: model)
        XCTAssertEqual(view.playbackTime, "-1:01")
    }

    func testWithPositiveCurrentTime() {
        let model = Model.readyToPlay(.init(duration: 60, currentTime: 20))
        let view = Module.view(for: model)
        XCTAssertEqual(view.playbackTime, "-0:40")
    }
    
}
