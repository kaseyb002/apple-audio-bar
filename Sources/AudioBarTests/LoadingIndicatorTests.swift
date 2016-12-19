import XCTest
@testable import AudioBar

final class LoadingIndicatorTests: XCTestCase {

    func testWithNoCurrentTimeWhenPlaying() {
        let model = Model.readyToPlay(.init(isPlaying: true, currentTime: nil))
        let view = Module.view(for: model)
        XCTAssertTrue(view.isLoadingIndicatorVisible)
    }

    func testWithNoCurrentTimeWhenPaused() {
        let model = Model.readyToPlay(.init(isPlaying: false, currentTime: nil))
        let view = Module.view(for: model)
        XCTAssertFalse(view.isLoadingIndicatorVisible)
    }

    func testWithPositiveCurrentTimeWhenPlaying() {
        let model = Model.readyToPlay(.init(isPlaying: true, currentTime: 0))
        let view = Module.view(for: model)
        XCTAssertFalse(view.isLoadingIndicatorVisible)
    }

    func testWithPositiveCurrentTimeWhenPaused() {
        let model = Model.readyToPlay(.init(isPlaying: false, currentTime: 0))
        let view = Module.view(for: model)
        XCTAssertFalse(view.isLoadingIndicatorVisible)
    }

}
