import XCTest
@testable import AudioBar

final class SimpleViewTests: XCTestCase {

    func testWhenWaitingForURL() {
        let model = Model.waitingForURL
        let view = Module.view(for: model)
        XCTAssertEqual(view, View(
            playPauseButtonMode: .play,
            isPlayPauseButtonEnabled: false,
            areSeekButtonsHidden: true,
            playbackTime: "",
            isSeekBackButtonEnabled: false,
            isSeekForwardButtonEnabled: false,
            isLoadingIndicatorVisible: false
        ))
    }

    func testWhenReadyToLoad() {
        let model = Model.readyToLoadURL(URL.arbitrary)
        let view = Module.view(for: model)
        XCTAssertEqual(view, View(
            playPauseButtonMode: .play,
            isPlayPauseButtonEnabled: true,
            areSeekButtonsHidden: true,
            playbackTime: "",
            isSeekBackButtonEnabled: false,
            isSeekForwardButtonEnabled: false,
            isLoadingIndicatorVisible: false
        ))
    }

    func testWhenWaitingForPlayerToBecomeReadyToPlayURL() {
        let model = Model.waitingForPlayerToBecomeReadyToPlayURL(URL.arbitrary)
        let view = Module.view(for: model)
        XCTAssertEqual(view, View(
            playPauseButtonMode: .pause,
            isPlayPauseButtonEnabled: true,
            areSeekButtonsHidden: true,
            playbackTime: "",
            isSeekBackButtonEnabled: false,
            isSeekForwardButtonEnabled: false,
            isLoadingIndicatorVisible: true
        ))
    }

}
