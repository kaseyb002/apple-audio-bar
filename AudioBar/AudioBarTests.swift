import XCTest
import Elm

@testable import AudioBar

class AudioBarTests: XCTestCase, Tests {

    typealias Module = AudioBar
    let failureReporter = XCTFail

    // MARK: Start

    func testDefaultModel() {
        let model = expectModel(loading: .init())
        expect(model, .waitingForURL)
    }

    // MARK: Update

    func testLoadTrack() {
        let update = expectUpdate(for: .prepareToLoad(URL.arbitrary), model: .waitingForURL)
        expect(update?.model, .readyToLoadURL(URL.arbitrary))
    }

    func testPlayerDidBecomeReadyToPlay() {
        let update = expectUpdate(for: .playerDidBecomeReadyToPlay(withDuration: 1), model: .waitingForPlayerToBecomeReadyToPlayURL(URL.arbitrary))
        expect(update?.model, .readyToPlay(.init(isPlaying: true, duration: 1, currentTime: nil)))
        expect(update?.command, .player(.play))
    }

    func testPlayerDidBecomeReadyToPlayUnexpectedly1() {
        let failure = expectFailure(for: .playerDidBecomeReadyToPlay(withDuration: 0), model: .waitingForURL)
        expect(failure, .playerIsNotWaitingToBecomeReadyToPlay)
    }

    func testPlayerDidBecomeReadyToPlayUnexpectedly2() {
        let failure = expectFailure(for: .playerDidBecomeReadyToPlay(withDuration: 0), model: .readyToLoadURL(URL.arbitrary))
        expect(failure, .playerIsNotWaitingToBecomeReadyToPlay)
    }

    func testPlayerDidBecomeReadyToPlayUnexpectedly3() {
        let failure = expectFailure(for: .playerDidBecomeReadyToPlay(withDuration: 0), model: .readyToPlay(.init()))
        expect(failure, .playerIsNotWaitingToBecomeReadyToPlay)
    }

    func testPlayerDidFailToBecomeReady() {
        let update = expectUpdate(for: .playerDidFailToBecomeReady, model: .waitingForPlayerToBecomeReadyToPlayURL(URL.arbitrary))
        expect(update?.model, .readyToLoadURL(URL.arbitrary))
        expect(update?.commands, [.player(.reset), .showAlert(text: "Unable to load media", button: "OK")])
    }

    func testPlayerDidFailToBecomeReadyUnexpectedly1() {
        let failure = expectFailure(for: .playerDidFailToBecomeReady, model: .waitingForURL)
        expect(failure, .playerIsNotWaitingToBecomeReadyToPlay)
    }

    func testPlayerDidFailToBecomeReadyUnexpectedly2() {
        let failure = expectFailure(for: .playerDidFailToBecomeReady, model: .readyToLoadURL(URL.arbitrary))
        expect(failure, .playerIsNotWaitingToBecomeReadyToPlay)
    }

    func testPlayerDidFailToBecomeReadyUnexpectedly3() {
        let failure = expectFailure(for: .playerDidFailToBecomeReady, model: .readyToPlay(.init()))
        expect(failure, .playerIsNotWaitingToBecomeReadyToPlay)
    }

    func testPlayerDidUpdateCurrentTime1() {
        let update = expectUpdate(for: .playerDidUpdateCurrentTime(1), model: .readyToPlay(.init(currentTime: 0)))
        expect(update?.model, .readyToPlay(.init(currentTime: 1)))
    }

    func testPlayerDidUpdateCurrentTime2() {
        let update = expectUpdate(for: .playerDidUpdateCurrentTime(2), model: .readyToPlay(.init(currentTime: 1)))
        expect(update?.model, .readyToPlay(.init(currentTime: 2)))
    }

    func testPlayerDidUpdateCurrentTimeUnexpectedly1() {
        let failure = expectFailure(for: .playerDidUpdateCurrentTime(0), model: .waitingForURL)
        expect(failure, .playerIsNotReadyToPlay)
    }

    func testPlayerDidUpdateCurrentTimeUnexpectedly2() {
        let failure = expectFailure(for: .playerDidUpdateCurrentTime(0), model: .readyToLoadURL(URL.arbitrary))
        expect(failure, .playerIsNotReadyToPlay)
    }

    func testPlayerDidUpdateCurrentTimeUnexpectedly3() {
        let failure = expectFailure(for: .playerDidUpdateCurrentTime(0), model: .waitingForPlayerToBecomeReadyToPlayURL(URL.arbitrary))
        expect(failure, .playerIsNotReadyToPlay)
    }

    func testPlayerDidPlayToEnd() {
        let update = expectUpdate(for: .playerDidPlayToEnd, model: .readyToPlay(.init(isPlaying: true, duration: 60, currentTime: 0)))
        expect(update?.model, .readyToPlay(.init(isPlaying: false, duration: 60, currentTime: 60)))
    }

    func testPlayerDidPlayToEndUnexpectedly1() {
        let failure = expectFailure(for: .playerDidPlayToEnd, model: .readyToPlay(.init(isPlaying: false)))
        expect(failure, .playerIsNotPlaying)
    }

    func testPlayerDidPlayToEndUnexpectedly2() {
        let failure = expectFailure(for: .playerDidPlayToEnd, model: .waitingForURL)
        expect(failure, .playerIsNotReadyToPlay)
    }

    func testPlayerDidPlayToEndUnexpectedly3() {
        let failure = expectFailure(for: .playerDidPlayToEnd, model: .readyToLoadURL(URL.arbitrary))
        expect(failure, .playerIsNotReadyToPlay)
    }

    func testPlayerDidPlayToEndUnexpectedly4() {
        let failure = expectFailure(for: .playerDidPlayToEnd, model: .waitingForPlayerToBecomeReadyToPlayURL(URL.arbitrary))
        expect(failure, .playerIsNotReadyToPlay)
    }

    func testSeekBack1() {
        let update = expectUpdate(for: .seekBack, model: .readyToPlay(.init(duration: 60, currentTime: 60)))
        expect(update?.model, .readyToPlay(.init(duration: 60, currentTime: 60 - 15)))
        expect(update?.command, .player(.setCurrentTime(60 - 15)))
    }

    func testSeekBack2() {
        let update = expectUpdate(for: .seekBack, model: .readyToPlay(.init(duration: 60, currentTime: 15)))
        expect(update?.command, .player(.setCurrentTime(15 - 15)))
        expect(update?.model, .readyToPlay(.init(duration: 60, currentTime: 15 - 15)))
    }

    func testSeekBackNearBeginning1() {
        let update = expectUpdate(for: .seekBack, model: .readyToPlay(.init(duration: 60, currentTime: 1)))
        expect(update?.model, .readyToPlay(.init(duration: 60, currentTime: 0)))
        expect(update?.command, .player(.setCurrentTime(0)))
    }

    func testSeekBackNearBeginning2() {
        let update = expectUpdate(for: .seekBack, model: .readyToPlay(.init(duration: 60, currentTime: 2)))
        expect(update?.model, .readyToPlay(.init(duration: 60, currentTime: 0)))
        expect(update?.command, .player(.setCurrentTime(0)))
    }

    func testSeekBackUnexpectedly1() {
        let failure = expectFailure(for: .seekBack, model: .waitingForURL)
        expect(failure, .playerIsNotReadyToPlay)
    }

    func testSeekBackUnexpectedly2() {
        let failure = expectFailure(for: .seekBack, model: .readyToLoadURL(URL.arbitrary))
        expect(failure, .playerIsNotReadyToPlay)
    }

    func testSeekBackUnexpectedly3() {
        let failure = expectFailure(for: .seekBack, model: .waitingForPlayerToBecomeReadyToPlayURL(URL.arbitrary))
        expect(failure, .playerIsNotReadyToPlay)
    }

    func testSeekForward1() {
        let update = expectUpdate(for: .seekForward, model: .readyToPlay(.init(duration: 60, currentTime: 0)))
        expect(update?.model, .readyToPlay(.init(duration: 60, currentTime: 0 + 15)))
        expect(update?.command, .player(.setCurrentTime(0 + 15)))
    }

    func testSeekForward2() {
        let update = expectUpdate(for: .seekForward, model: .readyToPlay(.init(duration: 60, currentTime: 1)))
        expect(update?.model, .readyToPlay(.init(duration: 60, currentTime: 1 + 15)))
        expect(update?.command, .player(.setCurrentTime(1 + 15)))
    }

    func testSeekForwardNearEndWhenPlaying1() {
        let update = expectUpdate(for: .seekForward, model: .readyToPlay(.init(isPlaying: true, duration: 60, currentTime: 59)))
        expect(update?.model, .readyToPlay(.init(isPlaying: false, duration: 60, currentTime: 60)))
        expect(update?.commands, [.player(.setCurrentTime(60)), .player(.pause)])
    }

    func testSeekForwardNearEndWhenPlaying2() {
        let update = expectUpdate(for: .seekForward, model: .readyToPlay(.init(isPlaying: true, duration: 60, currentTime: 58)))
        expect(update?.model, .readyToPlay(.init(isPlaying: false, duration: 60, currentTime: 60)))
        expect(update?.commands, [.player(.setCurrentTime(60)), .player(.pause)])
    }

    func testSeekForwardNearEndWhenPaused1() {
        let update = expectUpdate(for: .seekForward, model: .readyToPlay(.init(isPlaying: false, duration: 60, currentTime: 59)))
        expect(update?.command, .player(.setCurrentTime(60)))
    }

    func testSeekForwardNearEndWhenPaused2() {
        let update = expectUpdate(for: .seekForward, model: .readyToPlay(.init(isPlaying: false, duration: 60, currentTime: 58)))
        expect(update?.command, .player(.setCurrentTime(60)))
    }

    func testSeekForwardUnexpectedly1() {
        let failure = expectFailure(for: .seekForward, model: .waitingForURL)
        expect(failure, .playerIsNotReadyToPlay)
    }

    func testSeekForwardUnexpectedly2() {
        let failure = expectFailure(for: .seekForward, model: .readyToLoadURL(URL.arbitrary))
        expect(failure, .playerIsNotReadyToPlay)
    }

    func testSeekForwardUnexpectedly3() {
        let failure = expectFailure(for: .seekForward, model: .waitingForPlayerToBecomeReadyToPlayURL(URL.arbitrary))
        expect(failure, .playerIsNotReadyToPlay)
    }

    func testTogglePlayWhenReadyToLoadURL() {
        let update = expectUpdate(for: .togglePlay, model: .readyToLoadURL(URL.arbitrary))
        expect(update?.model, .waitingForPlayerToBecomeReadyToPlayURL(URL.arbitrary))
        expect(update?.command, .player(.loadURL(URL.arbitrary)))
    }

    func testTogglePlayWhenPlaying() {
        let update = expectUpdate(for: .togglePlay, model: .readyToPlay(.init(isPlaying: true)))
        expect(update?.model, .readyToPlay(.init(isPlaying: false)))
        expect(update?.command, .player(.pause))
    }

    func testTogglePlayWhenPaused() {
        let update = expectUpdate(for: .togglePlay, model: .readyToPlay(.init(isPlaying: false)))
        expect(update?.model, .readyToPlay(.init(isPlaying: true)))
        expect(update?.command, .player(.play))
    }

    func testTogglePlayWhenWaitingForPlayerToBecomeReadyToPlayURL() {
        let update = expectUpdate(for: .togglePlay, model: .waitingForPlayerToBecomeReadyToPlayURL(URL.arbitrary))
        expect(update?.model, .readyToLoadURL(URL.arbitrary))
        expect(update?.command, .player(.reset))
    }

    func testTogglePlayUnexpectedly() {
        let failure = expectFailure(for: .togglePlay, model: .waitingForURL)
        expect(failure, .emptyURL)
    }

    // MARK: View

    func testViewWhenWaitingForURL() {
        let view = expectView(presenting: .waitingForURL)
        expect(view?.playPauseButtonMode, .play)
        expect(view?.isPlayPauseButtonEnabled, false)
        expect(view?.areSeekButtonsHidden, true)
        expect(view?.playbackTime, "")
        expect(view?.isSeekBackButtonEnabled, false)
        expect(view?.isSeekForwardButtonEnabled, false)
        expect(view?.isLoadingIndicatorVisible, false)
    }

    func testViewWhenReadyToLoad() {
        let view = expectView(presenting: .readyToLoadURL(URL.arbitrary))
        expect(view?.playPauseButtonMode, .play)
        expect(view?.isPlayPauseButtonEnabled, true)
        expect(view?.areSeekButtonsHidden, true)
        expect(view?.playbackTime, "")
        expect(view?.isSeekBackButtonEnabled, false)
        expect(view?.isSeekForwardButtonEnabled, false)
        expect(view?.isLoadingIndicatorVisible, false)
    }

    func testViewWhenWaitingForPlayer() {
        let view = expectView(presenting: .waitingForPlayerToBecomeReadyToPlayURL(URL.arbitrary))
        expect(view?.playPauseButtonMode, .pause)
        expect(view?.isPlayPauseButtonEnabled, true)
        expect(view?.areSeekButtonsHidden, true)
        expect(view?.playbackTime, "")
        expect(view?.isSeekBackButtonEnabled, false)
        expect(view?.isSeekForwardButtonEnabled, false)
        expect(view?.isLoadingIndicatorVisible, true)
    }

    func testPlaybackTime1() {
        let view = expectView(presenting: .readyToPlay(.init(currentTime: nil)))
        expect(view?.playbackTime, "")
    }

    func testPlaybackTime2() {
        let view = expectView(presenting: .readyToPlay(.init(duration: 1, currentTime: 0)))
        expect(view?.playbackTime, "-0:01")
    }

    func testPlaybackTime3() {
        let view = expectView(presenting: .readyToPlay(.init(duration: 61, currentTime: 0)))
        expect(view?.playbackTime, "-1:01")
    }

    func testPlaybackTime4() {
        let view = expectView(presenting: .readyToPlay(.init(duration: 60, currentTime: 20)))
        expect(view?.playbackTime, "-0:40")
    }

    func testIsLoadingIndicatorVisible1() {
        let view = expectView(presenting: .readyToPlay(.init(isPlaying: true, currentTime: nil)))
        expect(view?.isLoadingIndicatorVisible, true)
    }

    func testIsLoadingIndicatorVisible2() {
        let view = expectView(presenting: .readyToPlay(.init(isPlaying: false, currentTime: nil)))
        expect(view?.isLoadingIndicatorVisible, false)
    }

    func testIsLoadingIndicatorVisible3() {
        let view = expectView(presenting: .readyToPlay(.init(isPlaying: true, currentTime: 0)))
        expect(view?.isLoadingIndicatorVisible, false)
    }

    func testIsLoadingIndicatorVisible4() {
        let view = expectView(presenting: .readyToPlay(.init(isPlaying: false, currentTime: 0)))
        expect(view?.isLoadingIndicatorVisible, false)
    }

    func testIsSeekBackButtonEnabled1() {
        let view = expectView(presenting: .readyToPlay(.init(currentTime: nil)))
        expect(view?.isSeekBackButtonEnabled, false)
    }

    func testIsSeekBackButtonEnabled2() {
        let view = expectView(presenting: .readyToPlay(.init(duration: 60, currentTime: 0)))
        expect(view?.isSeekBackButtonEnabled, false)
    }

    func testIsSeekBackButtonEnabled3() {
        let view = expectView(presenting: .readyToPlay(.init(duration: 60, currentTime: 1)))
        expect(view?.isSeekBackButtonEnabled, true)
    }

    func testIsSeekBackButtonEnabled4() {
        let view = expectView(presenting: .readyToPlay(.init(duration: 60, currentTime: 2)))
        expect(view?.isSeekBackButtonEnabled, true)
    }

    func testIsSeekForwardButtonEnabled1() {
        let view = expectView(presenting: .readyToPlay(.init(currentTime: nil)))
        expect(view?.isSeekForwardButtonEnabled, false)
    }

    func testIsSeekForwardButtonEnabled2() {
        let view = expectView(presenting: .readyToPlay(.init(duration: 60, currentTime: 58)))
        expect(view?.isSeekForwardButtonEnabled, true)
    }

    func testIsSeekForwardButtonEnabled3() {
        let view = expectView(presenting: .readyToPlay(.init(duration: 60, currentTime: 59)))
        expect(view?.isSeekForwardButtonEnabled, true)
    }

    func testIsSeekForwardButtonEnabled4() {
        let view = expectView(presenting: .readyToPlay(.init(duration: 60, currentTime: 60)))
        expect(view?.isSeekForwardButtonEnabled, false)
    }

    func testPlayPauseButtonMode1() {
        let view = expectView(presenting: .readyToPlay(.init(isPlaying: false)))
        expect(view?.playPauseButtonMode, .play)
    }

    func testPlayPauseButtonMode2() {
        let view = expectView(presenting: .readyToPlay(.init(isPlaying: true)))
        expect(view?.playPauseButtonMode, .pause)
    }

    func testIsPlayPauseButtonEnabled1() {
        let view = expectView(presenting: .readyToPlay(.init(currentTime: nil)))
        expect(view?.isPlayPauseButtonEnabled, true)
    }

    func testIsPlayPauseButtonEnabled2() {
        let view = expectView(presenting: .readyToPlay(.init(duration: 60, currentTime: 60)))
        expect(view?.isPlayPauseButtonEnabled, false)
    }

    func testIsPlayPauseButtonEnabled3() {
        let view = expectView(presenting: .readyToPlay(.init(duration: 60, currentTime: 59)))
        expect(view?.isPlayPauseButtonEnabled, true)
    }

    func testIsPlayPauseButtonEnabled4() {
        let view = expectView(presenting: .readyToPlay(.init(duration: 60, currentTime: 58)))
        expect(view?.isPlayPauseButtonEnabled, true)
    }

}

extension AudioBar.Model.ReadyState {
    init(isPlaying: Bool = false, duration: TimeInterval = 60, currentTime: TimeInterval? = nil) {
        self.isPlaying = isPlaying
        self.duration = duration
        self.currentTime = currentTime
    }
}

extension URL {
    static var arbitrary: URL {
        return URL(string: "foo")!
    }
}
