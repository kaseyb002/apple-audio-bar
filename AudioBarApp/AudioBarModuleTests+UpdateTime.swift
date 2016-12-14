import XCTest
@testable import AudioBarApp

extension AudioBarModuleTests {

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
        var model = Model.waitingForPlayerToLoadMedia
        XCTAssertThrowsError(try Module.update(for: .playerDidUpdateCurrentTime(1), model: &model))
    }
    
}
