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

    func testSetDuration() {
        do {
            var model = Model.waitingForDuration
            let commands = try! Module.update(for: .setDuration(1), model: &model)
            XCTAssertEqual(model, .readyToPlay(.init(isPlaying: true, duration: 1, currentTime: 0)))
            XCTAssertEqual(commands, [.player(.play)])
        }
        do {
            var model = Model.waitingForDuration
            let commands = try! Module.update(for: .setDuration(2), model: &model)
            XCTAssertEqual(model, .readyToPlay(.init(isPlaying: true, duration: 2, currentTime: 0)))
            XCTAssertEqual(commands, [.player(.play)])
        }
    }

    func testSetDurationUnexpectedly() {
        do {
            var model = Model.waitingForURL
            XCTAssertThrowsError(try Module.update(for: .setDuration(1), model: &model))
        }
        do {
            var model = Model.readyToLoad(URL.foo)
            XCTAssertThrowsError(try Module.update(for: .setDuration(1), model: &model))
        }
        do {
            var model = Model.readyToPlay(.init())
            XCTAssertThrowsError(try Module.update(for: .setDuration(1), model: &model))
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

    //
    // MARK: -
    // MARK: Set current time
    //

    func testSetCurrentTime() {
        var model = Model.readyToPlay(.init(currentTime: 1))
        let commands = try! Module.update(for: .setCurrentTime(2), model: &model)
        XCTAssertEqual(model, .readyToPlay(.init(currentTime: 2)))
        XCTAssertTrue(commands.isEmpty)
    }

    func testSetCurrentTimeUnexpectedly() {
        do {
            var model = Model.waitingForURL
            XCTAssertThrowsError(try Module.update(for: .setCurrentTime(1), model: &model))
        }
        do {
            var model = Model.readyToLoad(URL.foo)
            XCTAssertThrowsError(try Module.update(for: .setCurrentTime(1), model: &model))
        }
        do {
            var model = Model.waitingForDuration
            XCTAssertThrowsError(try Module.update(for: .setCurrentTime(1), model: &model))
        }
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
            playbackTime: "")
        )
    }

    func testViewWhenReadyToLoad() {
        let model = Model.readyToLoad(URL.foo)
        let view = Module.view(for: model)
        XCTAssertEqual(view, View(
            playPauseButtonMode: .play,
            isPlayPauseButtonEnabled: true,
            areSeekButtonsHidden: true,
            playbackTime: "")
        )
    }

    func testViewWhenLoading() {
        let model = Model.waitingForDuration
        let view = Module.view(for: model)
        XCTAssertEqual(view, View(playPauseButtonMode: .play, isPlayPauseButtonEnabled: false, areSeekButtonsHidden: true, playbackTime: "Loading"))
    }

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
