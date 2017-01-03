import XCTest
import Elm

@testable import AudioBar

class AudioBarUpdateTests: XCTestCase, UpdateTests {

    var fixture = UpdateFixture<AudioBarModule>()
    let failureReporter = XCTFail

    func testLoadTrack() {
        model = .waitingForURL
        message = .prepareToLoad(URL.arbitrary)
        expect(model, .readyToLoadURL(URL.arbitrary))
    }

    func testPlayerDidBecomeReadyToPlay() {
        model = .waitingForPlayerToBecomeReadyToPlayURL(URL.arbitrary)
        message = .playerDidBecomeReadyToPlay(withDuration: 1)
        expect(model, .readyToPlay(.init(isPlaying: true, duration: 1, currentTime: nil)))
        expect(command, .player(.play))
    }

    func testPlayerDidBecomeReadyToPlayUnexpectedly1() {
        model = .waitingForURL
        message = .playerDidBecomeReadyToPlay(withDuration: 0)
        expect(failure, .genericError)
    }

    func testPlayerDidBecomeReadyToPlayUnexpectedly2() {
        model = .readyToLoadURL(URL.arbitrary)
        message = .playerDidBecomeReadyToPlay(withDuration: 0)
        expect(failure, .genericError)
    }

    func testPlayerDidBecomeReadyToPlayUnexpectedly3() {
        model = .readyToPlay(.init())
        message = .playerDidBecomeReadyToPlay(withDuration: 0)
        expect(failure, .genericError)
    }

    func testPlayerDidFailToBecomeReady() {
        model = .waitingForPlayerToBecomeReadyToPlayURL(URL.arbitrary)
        message = .playerDidFailToBecomeReady
        expect(model, .readyToLoadURL(URL.arbitrary))
        expect(commands, [.player(.reset), .showAlert(text: "Unable to load media", button: "OK")])
    }

    func testPlayerDidFailToBecomeReadyUnexpectedly1() {
        model = .waitingForURL
        message = .playerDidFailToBecomeReady
        expect(failure, .genericError)
    }

    func testPlayerDidFailToBecomeReadyUnexpectedly2() {
        model = .readyToLoadURL(URL.arbitrary)
        message = .playerDidFailToBecomeReady
        expect(failure, .genericError)
    }

    func testPlayerDidFailToBecomeReadyUnexpectedly3() {
        model = .readyToPlay(.init())
        message = .playerDidFailToBecomeReady
        expect(failure, .genericError)
    }

    func testPlayerDidUpdateCurrentTime1() {
        model = .readyToPlay(.init(currentTime: 0))
        message = .playerDidUpdateCurrentTime(1)
        expect(model, .readyToPlay(.init(currentTime: 1)))
    }

    func testPlayerDidUpdateCurrentTime2() {
        model = .readyToPlay(.init(currentTime: 1))
        message = .playerDidUpdateCurrentTime(2)
        expect(model, .readyToPlay(.init(currentTime: 2)))
    }

    func testPlayerDidUpdateCurrentTimeUnexpectedly1() {
        model = .waitingForURL
        message = .playerDidUpdateCurrentTime(0)
        expect(failure, .genericError)
    }

    func testPlayerDidUpdateCurrentTimeUnexpectedly2() {
        model = .readyToLoadURL(URL.arbitrary)
        message = .playerDidUpdateCurrentTime(0)
        expect(failure, .genericError)
    }

    func testPlayerDidUpdateCurrentTimeUnexpectedly3() {
        model = .waitingForPlayerToBecomeReadyToPlayURL(URL.arbitrary)
        message = .playerDidUpdateCurrentTime(0)
        expect(failure, .genericError)
    }

    func testPlayerDidPlayToEnd() {
        model = .readyToPlay(.init(isPlaying: true, duration: 60, currentTime: 0))
        message = .playerDidPlayToEnd
        expect(model, .readyToPlay(.init(isPlaying: false, duration: 60, currentTime: 60)))
    }

    func testPlayerDidPlayToEndUnexpectedly1() {
        model = .readyToPlay(.init(isPlaying: false))
        message = .playerDidPlayToEnd
        expect(failure, .genericError)
    }

    func testPlayerDidPlayToEndUnexpectedly2() {
        model = .waitingForURL
        message = .playerDidPlayToEnd
        expect(failure, .genericError)
    }

    func testPlayerDidPlayToEndUnexpectedly3() {
        model = .readyToLoadURL(URL.arbitrary)
        message = .playerDidPlayToEnd
        expect(failure, .genericError)
    }

    func testPlayerDidPlayToEndUnexpectedly4() {
        model = .waitingForPlayerToBecomeReadyToPlayURL(URL.arbitrary)
        message = .playerDidPlayToEnd
        expect(failure, .genericError)
    }

    func testSeekBack1() {
        model = .readyToPlay(.init(duration: 60, currentTime: 60))
        message = .seekBack
        expect(model, .readyToPlay(.init(duration: 60, currentTime: 60 - 15)))
        expect(command, .player(.setCurrentTime(60 - 15)))
    }

    func testSeekBack2() {
        model = .readyToPlay(.init(duration: 60, currentTime: 15))
        message = .seekBack
        expect(command, .player(.setCurrentTime(15 - 15)))
        expect(model, .readyToPlay(.init(duration: 60, currentTime: 15 - 15)))
    }

    func testSeekBackNearBeginning1() {
        model = .readyToPlay(.init(duration: 60, currentTime: 1))
        message = .seekBack
        expect(model, .readyToPlay(.init(duration: 60, currentTime: 0)))
        expect(command, .player(.setCurrentTime(0)))
    }

    func testSeekBackNearBeginning2() {
        model = .readyToPlay(.init(duration: 60, currentTime: 2))
        message = .seekBack
        expect(model, .readyToPlay(.init(duration: 60, currentTime: 0)))
        expect(command, .player(.setCurrentTime(0)))
    }

    func testSeekBackUnexpectedly1() {
        model = .waitingForURL
        message = .seekBack
        expect(failure, .genericError)
    }

    func testSeekBackUnexpectedly2() {
        model = .readyToLoadURL(URL.arbitrary)
        message = .seekBack
        expect(failure, .genericError)
    }

    func testSeekBackUnexpectedly3() {
        model = .waitingForPlayerToBecomeReadyToPlayURL(URL.arbitrary)
        message = .seekBack
        expect(failure, .genericError)
    }

    func testSeekForward1() {
        model = .readyToPlay(.init(isPlaying: true, duration: 60, currentTime: 0))
        message = .seekForward
        expect(model, .readyToPlay(.init(isPlaying: true, duration: 60, currentTime: 0 + 15)))
        expect(command, .player(.setCurrentTime(0 + 15)))
    }

    func testSeekForward2() {
        model = .readyToPlay(.init(isPlaying: false, duration: 60, currentTime: 1))
        message = .seekForward
        expect(model, .readyToPlay(.init(isPlaying: false, duration: 60, currentTime: 1 + 15)))
        expect(command, .player(.setCurrentTime(1 + 15)))
    }

    func testSeekForwardNearEndWhenPlaying1() {
        model = .readyToPlay(.init(isPlaying: true, duration: 60, currentTime: 59))
        message = .seekForward
        expect(model, .readyToPlay(.init(isPlaying: false, duration: 60, currentTime: 60)))
        expect(commands, [.player(.setCurrentTime(60)), .player(.pause)])
    }

    func testSeekForwardNearEndWhenPlaying2() {
        model = .readyToPlay(.init(isPlaying: true, duration: 60, currentTime: 58))
        message = .seekForward
        expect(model, .readyToPlay(.init(isPlaying: false, duration: 60, currentTime: 60)))
        expect(commands, [.player(.setCurrentTime(60)), .player(.pause)])
    }

    func testSeekForwardNearEndWhenPaused1() {
        model = .readyToPlay(.init(isPlaying: false, duration: 60, currentTime: 59))
        message = .seekForward
        expect(command, .player(.setCurrentTime(60)))
    }

    func testSeekForwardNearEndWhenPaused2() {
        model = .readyToPlay(.init(isPlaying: false, duration: 60, currentTime: 58))
        message = .seekForward
        expect(command, .player(.setCurrentTime(60)))
    }

    func testSeekForwardUnexpectedly1() {
        model = .waitingForURL
        message = .seekForward
        expect(failure, .genericError)
    }

    func testSeekForwardUnexpectedly2() {
        model = .readyToLoadURL(URL.arbitrary)
        message = .seekForward
        expect(failure, .genericError)
    }

    func testSeekForwardUnexpectedly3() {
        model = .waitingForPlayerToBecomeReadyToPlayURL(URL.arbitrary)
        message = .seekForward
        expect(failure, .genericError)
    }

    func testTogglePlayWhenReadyToLoadURL() {
        model = .readyToLoadURL(URL.arbitrary)
        message = .togglePlay
        expect(model, .waitingForPlayerToBecomeReadyToPlayURL(URL.arbitrary))
        expect(command, .player(.loadURL(URL.arbitrary)))
    }

    func testTogglePlayWhenPlaying() {
        model = .readyToPlay(.init(isPlaying: true))
        message = .togglePlay
        expect(model, .readyToPlay(.init(isPlaying: false)))
        expect(command, .player(.pause))
    }

    func testTogglePlayWhenPaused() {
        model = .readyToPlay(.init(isPlaying: false))
        message = .togglePlay
        expect(model, .readyToPlay(.init(isPlaying: true)))
        expect(command, .player(.play))
    }

    func testTogglePlayWhenWaitingForPlayerToBecomeReadyToPlayURL() {
        model = .waitingForPlayerToBecomeReadyToPlayURL(URL.arbitrary)
        message = .togglePlay
        expect(model, .readyToLoadURL(URL.arbitrary))
        expect(command, .player(.reset))
    }
    
    func testTogglePlayUnexpectedly() {
        model = .waitingForURL
        message = .togglePlay
        expect(failure, .genericError)
    }
    
}
