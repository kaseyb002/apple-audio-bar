import XCTest
@testable import AudioBar

final class LoadingIndicatorTests: XCTestCase {

    func testWhenPausedWithCurrentTime() {
        let model = Model.readyToPlay(.init(isPlaying: false, currentTime: 0))
        let view = Module.view(for: model)
        XCTAssertFalse(view.isLoadingIndicatorVisible)
    }

    func testWhenPausedWithoutCurrentTime() {
        let model = Model.readyToPlay(.init(isPlaying: false, currentTime: nil))
        let view = Module.view(for: model)
        XCTAssertFalse(view.isLoadingIndicatorVisible)
    }

    func testWhenPlayingWithCurrentTime() {
        let model = Model.readyToPlay(.init(isPlaying: true, currentTime: 0))
        let view = Module.view(for: model)
        XCTAssertFalse(view.isLoadingIndicatorVisible)
    }

    func testWhenPlayingWithoutCurrentTime() {
        let model = Model.readyToPlay(.init(isPlaying: true, currentTime: nil))
        let view = Module.view(for: model)
        XCTAssertTrue(view.isLoadingIndicatorVisible)
    }
    
}
