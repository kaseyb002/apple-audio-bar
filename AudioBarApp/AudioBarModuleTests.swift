import XCTest
@testable import AudioBarApp

// Command Module

typealias Module = AudioBarModule

typealias Model = Module.Model
typealias View = Module.View
typealias Command = Module.Command

final class AudioBarModuleTests: XCTestCase {

    // Update tests

    func testDefaultModel() {
        let model = Model()
        XCTAssertEqual(model, .waitingForURL)
    }

}

//
// MARK: -
// MARK: Update tests
//

extension AudioBarModuleTests {

    //
    // MARK: -
    // MARK: Load track
    //

    func testLoadTrack() {
        do {
            var model = Model.waitingForURL
            let commands = try! Module.update(for: .prepareToLoad(URL.foo), model: &model)
            XCTAssertEqual(model, .readyToLoad(URL.foo))
            XCTAssertTrue(commands.isEmpty)
        }
        do {
            var model = Model.waitingForURL
            let commands = try! Module.update(for: .prepareToLoad(URL.bar), model: &model)
            XCTAssertEqual(model, .readyToLoad(URL.bar))
            XCTAssertTrue(commands.isEmpty)
        }
    }

    // TODO: Implement
    func testLoadTrackUnexpectedly() {}

    //
    // MARK: -
    // MARK: Set duration
    //

    func testPlayerDidUpdateDuration() {
        do {
            var model = Model.waitingForDuration
            let commands = try! Module.update(for: .playerDidUpdateDuration(1), model: &model)
            XCTAssertEqual(model, .readyToPlay(.init(isPlaying: true, duration: 1, currentTime: 0)))
            XCTAssertEqual(commands, [.player(.play)])
        }
        do {
            var model = Model.waitingForDuration
            let commands = try! Module.update(for: .playerDidUpdateDuration(2), model: &model)
            XCTAssertEqual(model, .readyToPlay(.init(isPlaying: true, duration: 2, currentTime: 0)))
            XCTAssertEqual(commands, [.player(.play)])
        }
    }

    func testplayerDidUpdateDurationUnexpectedly() {
        do {
            var model = Model.waitingForURL
            XCTAssertThrowsError(try Module.update(for: .playerDidUpdateDuration(1), model: &model))
        }
        do {
            var model = Model.readyToLoad(URL.foo)
            XCTAssertThrowsError(try Module.update(for: .playerDidUpdateDuration(1), model: &model))
        }
        do {
            var model = Model.readyToPlay(.init())
            XCTAssertThrowsError(try Module.update(for: .playerDidUpdateDuration(1), model: &model))
        }
    }

    //
    // MARK: -
    // MARK: Toggle play
    //

    func testTogglePlayWhenReadyToLoad() {
        do {
            var model = Model.readyToLoad(URL.foo)
            let commands = try! Module.update(for: .togglePlay, model: &model)
            XCTAssertEqual(model, .waitingForDuration)
            XCTAssertEqual(commands, [.player(.open(URL.foo))])
        }
        do {
            var model = Model.readyToLoad(URL.bar)
            let commands = try! Module.update(for: .togglePlay, model: &model)
            XCTAssertEqual(model, .waitingForDuration)
            XCTAssertEqual(commands, [.player(.open(URL.bar))])
        }
    }

    func testTogglePlayWhenPlaying() {
        var model = Model.readyToPlay(.init(isPlaying: true))
        let commands = try! Module.update(for: .togglePlay, model: &model)
        XCTAssertEqual(model, .readyToPlay(.init(isPlaying: false)))
        XCTAssertEqual(commands, [.player(.pause)])
    }

    func testTogglePlayWhenPaused() {
        var model = Model.readyToPlay(.init(isPlaying: false))
        let commands = try! Module.update(for: .togglePlay, model: &model)
        XCTAssertEqual(model, .readyToPlay(.init(isPlaying: true)))
        XCTAssertEqual(commands, [.player(.play)])
    }

    func testTogglePlayUnexpectedly() {
        do {
            var model = Model.waitingForURL
            XCTAssertThrowsError(try Module.update(for: .togglePlay, model: &model))
        }
        do {
            var model = Model.waitingForDuration
            XCTAssertThrowsError(try Module.update(for: .togglePlay, model: &model))
        }
    }

}

class AudioBarSeekBackTests: XCTestCase {

    func testSeekBack1() {
        var model = Model.readyToPlay(.init(duration: 60, currentTime: 60))
        let commands = try! Module.update(for: .seekBack, model: &model)
        XCTAssertEqual(model, .readyToPlay(.init(duration: 60, currentTime: 60 - 15)))
        XCTAssertEqual(commands, [.player(.setCurrentTime(45))])
    }

    func testSeekBack2() {
        var model = Model.readyToPlay(.init(duration: 60, currentTime: 15))
        let commands = try! Module.update(for: .seekBack, model: &model)
        XCTAssertEqual(model, .readyToPlay(.init(duration: 60, currentTime: 0)))
        XCTAssertEqual(commands, [.player(.setCurrentTime(0))])
    }

    func testSeekBackOvershoot1() {
        var model = Model.readyToPlay(.init(duration: 60, currentTime: 1))
        let commands = try! Module.update(for: .seekBack, model: &model)
        XCTAssertEqual(model, .readyToPlay(.init(duration: 60, currentTime: 0)))
        XCTAssertEqual(commands, [.player(.setCurrentTime(0))])
    }

    func testSeekBackOvershoot2() {
        var model = Model.readyToPlay(.init(duration: 60, currentTime: 2))
        let commands = try! Module.update(for: .seekBack, model: &model)
        XCTAssertEqual(model, .readyToPlay(.init(duration: 60, currentTime: 0)))
        XCTAssertEqual(commands, [.player(.setCurrentTime(0))])
    }

    func testSeekForwardWhenNotAllowed1() {
        var model = Model.waitingForURL
        XCTAssertThrowsError(try Module.update(for: .seekForward, model: &model))
    }

    func testSeekForwardWhenNotAllowed2() {
        var model = Model.readyToLoad(URL.foo)
        XCTAssertThrowsError(try Module.update(for: .seekForward, model: &model))
    }

    func testSeekForwardWhenNotAllowed3() {
        var model = Model.waitingForDuration
        XCTAssertThrowsError(try Module.update(for: .seekForward, model: &model))
    }

}

class AudioBarSeekForwardTests: XCTestCase {

    func testSeekForwardWhenPlaying1() {
        var model = Model.readyToPlay(.init(isPlaying: true, duration: 60, currentTime: 0))
        let commands = try! Module.update(for: .seekForward, model: &model)
        XCTAssertEqual(model, .readyToPlay(.init(isPlaying: true, duration: 60, currentTime: 15)))
        XCTAssertEqual(commands, [.player(.setCurrentTime(15))])
    }

    func testSeekForwardWhenPlaying2() {
        var model = Model.readyToPlay(.init(isPlaying: true, duration: 120, currentTime: 60))
        let commands = try! Module.update(for: .seekForward, model: &model)
        XCTAssertEqual(model, .readyToPlay(.init(isPlaying: true, duration: 120, currentTime: 75)))
        XCTAssertEqual(commands, [.player(.setCurrentTime(75))])
    }

    func testSeekForwardWhenPaused1() {
        var model = Model.readyToPlay(.init(isPlaying: false, duration: 60, currentTime: 0))
        let commands = try! Module.update(for: .seekForward, model: &model)
        XCTAssertEqual(model, .readyToPlay(.init(isPlaying: false, duration: 60, currentTime: 15)))
        XCTAssertEqual(commands, [.player(.setCurrentTime(15))])
    }

    func testSeekForwardWhenPaused2() {
        var model = Model.readyToPlay(.init(isPlaying: false, duration: 120, currentTime: 60))
        let commands = try! Module.update(for: .seekForward, model: &model)
        XCTAssertEqual(model, .readyToPlay(.init(isPlaying: false, duration: 120, currentTime: 75)))
        XCTAssertEqual(commands, [.player(.setCurrentTime(75))])
    }

    func testSeekForwardOvershootWhenPlaying1() {
        var model = Model.readyToPlay(.init(isPlaying: true, duration: 60, currentTime: 59))
        let commands = try! Module.update(for: .seekForward, model: &model)
        XCTAssertEqual(model, .readyToPlay(.init(isPlaying: false, duration: 60, currentTime: 60)))
        XCTAssertEqual(commands, [.player(.setCurrentTime(60)), .player(.pause)])
    }

    func testSeekForwardOvershootWhenPlaying2() {
        var model = Model.readyToPlay(.init(isPlaying: true, duration: 60, currentTime: 58))
        let commands = try! Module.update(for: .seekForward, model: &model)
        XCTAssertEqual(model, .readyToPlay(.init(isPlaying: false, duration: 60, currentTime: 60)))
        XCTAssertEqual(commands, [.player(.setCurrentTime(60)), .player(.pause)])
    }

    func testSeekForwardOvershootWhenPaused1() {
        var model = Model.readyToPlay(.init(isPlaying: false, duration: 60, currentTime: 59))
        let commands = try! Module.update(for: .seekForward, model: &model)
        XCTAssertEqual(model, .readyToPlay(.init(isPlaying: false, duration: 60, currentTime: 60)))
        XCTAssertEqual(commands, [.player(.setCurrentTime(60))])
    }

    func testSeekForwardOvershootWhenPaused2() {
        var model = Model.readyToPlay(.init(isPlaying: false, duration: 60, currentTime: 58))
        let commands = try! Module.update(for: .seekForward, model: &model)
        XCTAssertEqual(model, .readyToPlay(.init(isPlaying: false, duration: 60, currentTime: 60)))
        XCTAssertEqual(commands, [.player(.setCurrentTime(60))])
    }

    func testSeekBackWhenNotAllowed1() {
        var model = Model.waitingForURL
        XCTAssertThrowsError(try Module.update(for: .seekBack, model: &model))
    }

    func testSeekBackWhenNotAllowed2() {
        var model = Model.readyToLoad(URL.foo)
        XCTAssertThrowsError(try Module.update(for: .seekBack, model: &model))
    }

    func testSeekBackWhenNotAllowed3() {
        var model = Model.waitingForDuration
        XCTAssertThrowsError(try Module.update(for: .seekBack, model: &model))
    }

}

class AudioBarSetCurrentTimeTests: XCTestCase {

    func testPlayerDidUpdateCurrentTime1() {
        var model = Model.readyToPlay(.init(currentTime: 0))
        let commands = try! Module.update(for: .playerDidUpdateCurrentTime(1), model: &model)
        XCTAssertEqual(model, .readyToPlay(.init(currentTime: 1)))
        XCTAssertTrue(commands.isEmpty)
    }

    func testPlayerDidUpdateCurrentTime2() {
        var model = Model.readyToPlay(.init(currentTime: 1))
        let commands = try! Module.update(for: .playerDidUpdateCurrentTime(2), model: &model)
        XCTAssertEqual(model, .readyToPlay(.init(currentTime: 2)))
        XCTAssertTrue(commands.isEmpty)
    }

    func testPlayerDidUpdateCurrentTimeToEndWhenPlaying() {
        var model = Model.readyToPlay(.init(isPlaying: true, duration: 60, currentTime: 0))
        let commands = try! Module.update(for: .playerDidUpdateCurrentTime(60), model: &model)
        XCTAssertEqual(model, .readyToPlay(.init(isPlaying: false, duration: 60, currentTime: 60)))
        XCTAssertEqual(commands, [.player(.pause)])
    }

    func testPlayerDidUpdateCurrentTimeToEndWhenPaused() {
        var model = Model.readyToPlay(.init(isPlaying: false, duration: 60, currentTime: 0))
        let commands = try! Module.update(for: .playerDidUpdateCurrentTime(60), model: &model)
        XCTAssertEqual(model, .readyToPlay(.init(isPlaying: false, duration: 60, currentTime: 60)))
        XCTAssertTrue(commands.isEmpty)
    }

    func testPlayerDidUpdateCurrentTimePastEnd() {
        var model = Model.readyToPlay(.init(duration: 60))
        XCTAssertThrowsError(try Module.update(for: .playerDidUpdateCurrentTime(61), model: &model))
    }

    func testPlayerDidUpdateCurrentTimeToZero() {
        var model = Model.readyToPlay(.init(currentTime: 30))
        let commands = try! Module.update(for: .playerDidUpdateCurrentTime(0), model: &model)
        XCTAssertEqual(model, .readyToPlay(.init(currentTime: 0)))
        XCTAssertTrue(commands.isEmpty)
    }

    func testPlayerDidUpdateCurrentTimeToNegativeValue1() {
        var model = Model.readyToPlay(.init())
        XCTAssertThrowsError(try Module.update(for: .playerDidUpdateCurrentTime(-1), model: &model))
    }

    func testPlayerDidUpdateCurrentTimeToNegativeValue2() {
        var model = Model.readyToPlay(.init())
        XCTAssertThrowsError(try Module.update(for: .playerDidUpdateCurrentTime(-2), model: &model))
    }


    func testPlayerDidUpdateCurrentTimeUnexpectedly1() {
        var model = Model.waitingForURL
        XCTAssertThrowsError(try Module.update(for: .playerDidUpdateCurrentTime(1), model: &model))
    }

    func testPlayerDidUpdateCurrentTimeUnexpectedly2() {
        var model = Model.readyToLoad(URL.foo)
        XCTAssertThrowsError(try Module.update(for: .playerDidUpdateCurrentTime(1), model: &model))
    }

    func testPlayerDidUpdateCurrentTimeUnexpectedly3() {
        var model = Model.waitingForDuration
        XCTAssertThrowsError(try Module.update(for: .playerDidUpdateCurrentTime(1), model: &model))
    }

}

//
// MARK: -
// MARK: View tests
//

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

    func testViewWhenLoading() {
        let model = Model.waitingForDuration
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



    func testSeekBackButtonEnabled() {
        do {
            let model = Model.waitingForURL
            let view = Module.view(for: model)
            XCTAssertFalse(view.isSeekBackButtonEnabled)
        }
        do {
            let model = Model.readyToLoad(URL.foo)
            let view = Module.view(for: model)
            XCTAssertFalse(view.isSeekBackButtonEnabled)
        }
        do {
            let model = Model.waitingForDuration
            let view = Module.view(for: model)
            XCTAssertFalse(view.isSeekBackButtonEnabled)
        }
        do {
            do {
                let model = Model.readyToPlay(.init(currentTime: 0))
                let view = Module.view(for: model)
                XCTAssertFalse(view.isSeekBackButtonEnabled)
            }
            do {
                let model = Model.readyToPlay(.init(currentTime: 0.01))
                let view = Module.view(for: model)
                XCTAssertTrue(view.isSeekBackButtonEnabled)
            }
        }
    }

    func testSeekForwardButtonEnabled() {
        do {
            do {
                let model = Model.readyToPlay(.init(duration: 1, currentTime: 0.99))
                let view = Module.view(for: model)
                XCTAssertTrue(view.isSeekForwardButtonEnabled)
            }
            do {
                let model = Model.readyToPlay(.init(duration: 2, currentTime: 1.99))
                let view = Module.view(for: model)
                XCTAssertTrue(view.isSeekForwardButtonEnabled)
            }
        }
        do {
            do {
                let model = Model.readyToPlay(.init(duration: 1, currentTime: 1))
                let view = Module.view(for: model)
                XCTAssertFalse(view.isSeekForwardButtonEnabled)
            }
            do {
                let model = Model.readyToPlay(.init(duration: 2, currentTime: 2))
                let view = Module.view(for: model)
                XCTAssertFalse(view.isSeekForwardButtonEnabled)
            }
        }
    }

    //
    // MARK: -
    // MARK: Playback time
    //

    func testPlaybackTime() {
        do {
            let model = Model.readyToPlay(.init(duration: 1, currentTime: 0))
            let view = Module.view(for: model)
            XCTAssertEqual(view.playbackTime, "-0:01")
        }
        do {
            let model = Model.readyToPlay(.init(duration: 60 + 1, currentTime: 0))
            let view = Module.view(for: model)
            XCTAssertEqual(view.playbackTime, "-1:01")
        }
        do {
            let model = Model.readyToPlay(.init(duration: 60, currentTime: 20))
            let view = Module.view(for: model)
            XCTAssertEqual(view.playbackTime, "-0:40")
        }
    }

}

class PlayPauseButtonModeTests: XCTestCase {

    func testPlayPauseButtonModeWhenPaused() {
        let model = Model.readyToPlay(.init(isPlaying: false))
        let view = Module.view(for: model)
        XCTAssertEqual(view.playPauseButtonMode, .play)
    }

    func testPlayPauseButtonModeWhenPlaying() {
        let model = Model.readyToPlay(.init(isPlaying: true))
        let view = Module.view(for: model)
        XCTAssertEqual(view.playPauseButtonMode, .pause)
    }

    func testPlayPauseEnabled() {
        let model = Model.readyToPlay(.init(duration: 60, currentTime: 59))
        let view = Module.view(for: model)
        XCTAssertTrue(view.isPlayPauseButtonEnabled)
    }

    func testPlayButtonDisabledWhenNoTimeRemaining() {
        let model = Model.readyToPlay(.init(duration: 60, currentTime: 60))
        let view = Module.view(for: model)
        XCTAssertFalse(view.isPlayPauseButtonEnabled)
    }

}

//
// MARK: -
// MARK: Default initializers
//

extension Model.ReadyState {

    init(isPlaying: Bool = false, duration: TimeInterval = 2, currentTime: TimeInterval = 1) {
        self.isPlaying = isPlaying
        self.duration = duration
        self.currentTime = currentTime
    }

}

//
// MARK: -
// MARK: Equatable conformances
//

extension View: Equatable {
    public static func ==(lhs: View, rhs: View) -> Bool {
        return String(describing: lhs) == String(describing: rhs)
    }
}

extension Command: Equatable {
    public static func ==(lhs: Command, rhs: Command) -> Bool {
        return String(describing: lhs) == String(describing: rhs)
    }
}

extension Model: Equatable {
    public static func ==(lhs: Model, rhs: Model) -> Bool {
        return String(describing: lhs) == String(describing: rhs)
    }
}

//
// MARK: -
// MARK: Utilities
//

extension URL {

    static var foo: URL {
        return URL(string: "foo")!
    }
    
    static var bar: URL {
        return URL(string: "bar")!
    }
    
}
