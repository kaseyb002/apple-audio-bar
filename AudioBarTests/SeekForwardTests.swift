import XCTest
@testable import AudioBar

final class SeekForwardTests: XCTestCase {

    func testWhenPlaying1() {
        var model = Model.readyToPlay(.init(isPlaying: true, duration: 60, currentTime: 0))
        let commands = try! Module.update(for: .seekForward, model: &model)
        XCTAssertEqual(model, .readyToPlay(.init(isPlaying: true, duration: 60, currentTime: 15)))
        XCTAssertEqual(commands, [.player(.setCurrentTime(15))])
    }

    func testWhenPlaying2() {
        var model = Model.readyToPlay(.init(isPlaying: true, duration: 120, currentTime: 60))
        let commands = try! Module.update(for: .seekForward, model: &model)
        XCTAssertEqual(model, .readyToPlay(.init(isPlaying: true, duration: 120, currentTime: 75)))
        XCTAssertEqual(commands, [.player(.setCurrentTime(75))])
    }

    func testWhenPaused1() {
        var model = Model.readyToPlay(.init(isPlaying: false, duration: 60, currentTime: 0))
        let commands = try! Module.update(for: .seekForward, model: &model)
        XCTAssertEqual(model, .readyToPlay(.init(isPlaying: false, duration: 60, currentTime: 15)))
        XCTAssertEqual(commands, [.player(.setCurrentTime(15))])
    }

    func testWhenPaused2() {
        var model = Model.readyToPlay(.init(isPlaying: false, duration: 120, currentTime: 60))
        let commands = try! Module.update(for: .seekForward, model: &model)
        XCTAssertEqual(model, .readyToPlay(.init(isPlaying: false, duration: 120, currentTime: 75)))
        XCTAssertEqual(commands, [.player(.setCurrentTime(75))])
    }

    func testOvershootWhenPlaying1() {
        var model = Model.readyToPlay(.init(isPlaying: true, duration: 60, currentTime: 59))
        let commands = try! Module.update(for: .seekForward, model: &model)
        XCTAssertEqual(model, .readyToPlay(.init(isPlaying: false, duration: 60, currentTime: 60)))
        XCTAssertEqual(commands, [.player(.setCurrentTime(60)), .player(.pause)])
    }

    func testOvershootWhenPlaying2() {
        var model = Model.readyToPlay(.init(isPlaying: true, duration: 60, currentTime: 58))
        let commands = try! Module.update(for: .seekForward, model: &model)
        XCTAssertEqual(model, .readyToPlay(.init(isPlaying: false, duration: 60, currentTime: 60)))
        XCTAssertEqual(commands, [.player(.setCurrentTime(60)), .player(.pause)])
    }

    func testOvershootWhenPaused1() {
        var model = Model.readyToPlay(.init(isPlaying: false, duration: 60, currentTime: 59))
        let commands = try! Module.update(for: .seekForward, model: &model)
        XCTAssertEqual(model, .readyToPlay(.init(isPlaying: false, duration: 60, currentTime: 60)))
        XCTAssertEqual(commands, [.player(.setCurrentTime(60))])
    }

    func testOvershootWhenPaused2() {
        var model = Model.readyToPlay(.init(isPlaying: false, duration: 60, currentTime: 58))
        let commands = try! Module.update(for: .seekForward, model: &model)
        XCTAssertEqual(model, .readyToPlay(.init(isPlaying: false, duration: 60, currentTime: 60)))
        XCTAssertEqual(commands, [.player(.setCurrentTime(60))])
    }

    func testWhenUnexpected1() {
        var model = Model.waitingForURL
        XCTAssertThrowsError(try Module.update(for: .seekForward, model: &model))
    }

    func testWhenUnexpected2() {
        var model = Model.readyToLoadURL(URL.arbitrary)
        XCTAssertThrowsError(try Module.update(for: .seekForward, model: &model))
    }

    func testWhenUnexpected3() {
        var model = Model.waitingForPlayerToBecomeReadyToPlayURL(URL.arbitrary)
        XCTAssertThrowsError(try Module.update(for: .seekForward, model: &model))
    }

}
