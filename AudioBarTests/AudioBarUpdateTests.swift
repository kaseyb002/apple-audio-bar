import XCTest
import Elm

@testable import AudioBar

class AudioBarUpdateTests: XCTestCase, Tests {

    typealias Module = AudioBarModule
    let failureReporter = XCTFail

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
        expect(failure, .genericError)
    }

    func testPlayerDidBecomeReadyToPlayUnexpectedly2() {
        let failure = expectFailure(for: .playerDidBecomeReadyToPlay(withDuration: 0), model: .readyToLoadURL(URL.arbitrary))
        expect(failure, .genericError)
    }

    func testPlayerDidBecomeReadyToPlayUnexpectedly3() {
        let failure = expectFailure(for: .playerDidBecomeReadyToPlay(withDuration: 0), model: .readyToPlay(.init()))
        expect(failure, .genericError)
    }

    func testPlayerDidFailToBecomeReady() {
        let update = expectUpdate(for: .playerDidFailToBecomeReady, model: .waitingForPlayerToBecomeReadyToPlayURL(URL.arbitrary))
        expect(update?.model, .readyToLoadURL(URL.arbitrary))
        expect(update?.commands, [.player(.reset), .showAlert(text: "Unable to load media", button: "OK")])
    }

    func testPlayerDidFailToBecomeReadyUnexpectedly1() {
        let failure = expectFailure(for: .playerDidFailToBecomeReady, model: .waitingForURL)
        expect(failure, .genericError)
    }

    func testPlayerDidFailToBecomeReadyUnexpectedly2() {
        let failure = expectFailure(for: .playerDidFailToBecomeReady, model: .readyToLoadURL(URL.arbitrary))
        expect(failure, .genericError)
    }

    func testPlayerDidFailToBecomeReadyUnexpectedly3() {
        let failure = expectFailure(for: .playerDidFailToBecomeReady, model: .readyToPlay(.init()))
        expect(failure, .genericError)
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
        expect(failure, .genericError)
    }

    func testPlayerDidUpdateCurrentTimeUnexpectedly2() {
        let failure = expectFailure(for: .playerDidUpdateCurrentTime(0), model: .readyToLoadURL(URL.arbitrary))
        expect(failure, .genericError)
    }

    func testPlayerDidUpdateCurrentTimeUnexpectedly3() {
        let failure = expectFailure(for: .playerDidUpdateCurrentTime(0), model: .waitingForPlayerToBecomeReadyToPlayURL(URL.arbitrary))
        expect(failure, .genericError)
    }

    func testPlayerDidPlayToEnd() {
        let update = expectUpdate(for: .playerDidPlayToEnd, model: .readyToPlay(.init(isPlaying: true, duration: 60, currentTime: 0)))
        expect(update?.model, .readyToPlay(.init(isPlaying: false, duration: 60, currentTime: 60)))
    }

    func testPlayerDidPlayToEndUnexpectedly1() {
        let failure = expectFailure(for: .playerDidPlayToEnd, model: .readyToPlay(.init(isPlaying: false)))
        expect(failure, .genericError)
    }

    func testPlayerDidPlayToEndUnexpectedly2() {
        let failure = expectFailure(for: .playerDidPlayToEnd, model: .waitingForURL)
        expect(failure, .genericError)
    }

    func testPlayerDidPlayToEndUnexpectedly3() {
        let failure = expectFailure(for: .playerDidPlayToEnd, model: .readyToLoadURL(URL.arbitrary))
        expect(failure, .genericError)
    }

    func testPlayerDidPlayToEndUnexpectedly4() {
        let failure = expectFailure(for: .playerDidPlayToEnd, model: .waitingForPlayerToBecomeReadyToPlayURL(URL.arbitrary))
        expect(failure, .genericError)
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
        expect(failure, .genericError)
    }

    func testSeekBackUnexpectedly2() {
        let failure = expectFailure(for: .seekBack, model: .readyToLoadURL(URL.arbitrary))
        expect(failure, .genericError)
    }

    func testSeekBackUnexpectedly3() {
        let failure = expectFailure(for: .seekBack, model: .waitingForPlayerToBecomeReadyToPlayURL(URL.arbitrary))
        expect(failure, .genericError)
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
        expect(failure, .genericError)
    }

    func testSeekForwardUnexpectedly2() {
        let failure = expectFailure(for: .seekForward, model: .readyToLoadURL(URL.arbitrary))
        expect(failure, .genericError)
    }

    func testSeekForwardUnexpectedly3() {
        let failure = expectFailure(for: .seekForward, model: .waitingForPlayerToBecomeReadyToPlayURL(URL.arbitrary))
        expect(failure, .genericError)
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
        expect(failure, .genericError)
    }
    
}
