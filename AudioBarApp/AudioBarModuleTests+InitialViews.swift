import XCTest
@testable import AudioBarApp

extension AudioBarModuleTests {

    func testViewWhenWaitingForTrack() {
        let model = Model.waitingForURL
        let view = Module.view(for: model)
        XCTAssertEqual(view, View(
            playPauseButtonMode: .play,
            isPlayPauseButtonEnabled: false,
            areSeekButtonsHidden: true,
            playbackTime: "",
            isSeekBackButtonEnabled: false,
            isSeekForwardButtonEnabled: false
        ))
    }

    func testViewWhenReadyToLoad() {
        let model = Model.readyToLoad(URL.foo)
        let view = Module.view(for: model)
        XCTAssertEqual(view, View(
            playPauseButtonMode: .play,
            isPlayPauseButtonEnabled: true,
            areSeekButtonsHidden: true,
            playbackTime: "",
            isSeekBackButtonEnabled: false,
            isSeekForwardButtonEnabled: false
        ))
    }

    func testViewWhenWaitingForPlayerToLoadMedia() {
        let model = Model.waitingForPlayerToLoadMedia
        let view = Module.view(for: model)
        XCTAssertEqual(view, View(
            playPauseButtonMode: .play,
            isPlayPauseButtonEnabled: false,
            areSeekButtonsHidden: true,
            playbackTime: "Loading",
            isSeekBackButtonEnabled: false,
            isSeekForwardButtonEnabled: false
        ))
    }
    
}
