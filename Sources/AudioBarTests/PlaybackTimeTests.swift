import XCTest
@testable import AudioBar

final class PlaybackTimeTests: XCTestCase {

    func testWithCurrentTimeMissing() {
        let model = Model.readyToPlay(.init(currentTime: nil))
        let view = Module.view(for: model)
        XCTAssertEqual(view.playbackTime, "")
    }

    func testWhenAtBeginning1() {
        let model = Model.readyToPlay(.init(duration: 1, currentTime: 0))
        let view = Module.view(for: model)
        XCTAssertEqual(view.playbackTime, "-0:01")
    }

    func testWhenAtBeginning2() {
        let model = Model.readyToPlay(.init(duration: 61, currentTime: 0))
        let view = Module.view(for: model)
        XCTAssertEqual(view.playbackTime, "-1:01")
    }

    func testWhenPastBeginning() {
        let model = Model.readyToPlay(.init(duration: 60, currentTime: 20))
        let view = Module.view(for: model)
        XCTAssertEqual(view.playbackTime, "-0:40")
    }
    
}
