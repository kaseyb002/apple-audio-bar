import XCTest
import Elm

@testable import AudioBar

class AudioBarViewTests: XCTestCase, ViewTests {

    var fixture = ViewFixture<AudioBarModule>()
    let failureReporter = XCTFail

    func testViewWhenWaitingForURL() {
        model = .waitingForURL
        expect(view.playPauseButtonMode, .play)
        expect(view.isPlayPauseButtonEnabled, false)
        expect(view.areSeekButtonsHidden)
        expect(view.playbackTime, "")
        expect(view.isSeekBackButtonEnabled, false)
        expect(view.isSeekForwardButtonEnabled, false)
        expect(view.isLoadingIndicatorVisible, false)
    }

    func testViewWhenReadyToLoad() {
        model = .readyToLoadURL(URL.arbitrary)
        expect(view.playPauseButtonMode, .play)
        expect(view.isPlayPauseButtonEnabled)
        expect(view.areSeekButtonsHidden)
        expect(view.playbackTime, "")
        expect(view.isSeekBackButtonEnabled, false)
        expect(view.isSeekForwardButtonEnabled, false)
        expect(view.isLoadingIndicatorVisible, false)
    }

    func testViewWhenWaitingForPlayer() {
        model = .waitingForPlayerToBecomeReadyToPlayURL(URL.arbitrary)
        expect(view.playPauseButtonMode, .pause)
        expect(view.isPlayPauseButtonEnabled)
        expect(view.areSeekButtonsHidden)
        expect(view.playbackTime, "")
        expect(view.isSeekBackButtonEnabled, false)
        expect(view.isSeekForwardButtonEnabled, false)
        expect(view.isLoadingIndicatorVisible)
    }

    func testPlaybackTime1() {
        model = .readyToPlay(.init(currentTime: nil))
        expect(view.playbackTime, "")
    }

    func testPlaybackTime2() {
        model = .readyToPlay(.init(duration: 1, currentTime: 0))
        expect(view.playbackTime, "-0:01")
    }

    func testPlaybackTime3() {
        model = .readyToPlay(.init(duration: 61, currentTime: 0))
        expect(view.playbackTime, "-1:01")
    }

    func testPlaybackTime4() {
        model = .readyToPlay(.init(duration: 60, currentTime: 20))
        expect(view.playbackTime, "-0:40")
    }

    func testIsLoadingIndicatorVisible1() {
        model = .readyToPlay(.init(isPlaying: true, currentTime: nil))
        expect(view.isLoadingIndicatorVisible)
    }

    func testIsLoadingIndicatorVisible2() {
        model = .readyToPlay(.init(isPlaying: false, currentTime: nil))
        expect(view.isLoadingIndicatorVisible, false)
    }

    func testIsLoadingIndicatorVisible3() {
        model = .readyToPlay(.init(isPlaying: true, currentTime: 0))
        expect(view.isLoadingIndicatorVisible, false)
    }

    func testIsLoadingIndicatorVisible4() {
        model = .readyToPlay(.init(isPlaying: false, currentTime: 0))
        expect(view.isLoadingIndicatorVisible, false)
    }

    func testIsSeekBackButtonEnabled1() {
        model = .readyToPlay(.init(currentTime: nil))
        expect(view.isSeekBackButtonEnabled, false)
    }

    func testIsSeekBackButtonEnabled2() {
        model = .readyToPlay(.init(duration: 60, currentTime: 0))
        expect(view.isSeekBackButtonEnabled, false)
    }

    func testIsSeekBackButtonEnabled3() {
        model = .readyToPlay(.init(duration: 60, currentTime: 1))
        expect(view.isSeekBackButtonEnabled)
    }

    func testIsSeekBackButtonEnabled4() {
        model = .readyToPlay(.init(duration: 60, currentTime: 2))
        expect(view.isSeekBackButtonEnabled)
    }

    func testIsSeekForwardButtonEnabled1() {
        model = .readyToPlay(.init(currentTime: nil))
        expect(view.isSeekForwardButtonEnabled, false)
    }

    func testIsSeekForwardButtonEnabled2() {
        model = .readyToPlay(.init(duration: 60, currentTime: 58))
        expect(view.isSeekForwardButtonEnabled)
    }

    func testIsSeekForwardButtonEnabled3() {
        model = .readyToPlay(.init(duration: 60, currentTime: 59))
        expect(view.isSeekForwardButtonEnabled)
    }

    func testIsSeekForwardButtonEnabled4() {
        model = .readyToPlay(.init(duration: 60, currentTime: 60))
        expect(view.isSeekForwardButtonEnabled, false)
    }

    func testPlayPauseButtonMode1() {
        model = .readyToPlay(.init(isPlaying: false))
        expect(view.playPauseButtonMode, .play)
    }

    func testPlayPauseButtonMode2() {
        model = .readyToPlay(.init(isPlaying: true))
        expect(view.playPauseButtonMode, .pause)
    }

    func testIsPlayPauseButtonEnabled1() {
        model = .readyToPlay(.init(currentTime: nil))
        expect(view.isPlayPauseButtonEnabled)
    }

    func testIsPlayPauseButtonEnabled2() {
        model = .readyToPlay(.init(duration: 60, currentTime: 60))
        expect(view.isPlayPauseButtonEnabled, false)
    }

    func testIsPlayPauseButtonEnabled3() {
        model = .readyToPlay(.init(duration: 60, currentTime: 59))
        expect(view.isPlayPauseButtonEnabled)
    }

    func testIsPlayPauseButtonEnabled4() {
        model = .readyToPlay(.init(duration: 60, currentTime: 58))
        expect(view.isPlayPauseButtonEnabled)
    }
    
}
