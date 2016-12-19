import XCTest
@testable import AudioBar

final class SeekBackTests: XCTestCase {

    func testWithPositiveElapsedTime1() {
        var model = Model.readyToPlay(.init(duration: 60, currentTime: 60))
        let commands = try! Module.update(for: .seekBack, model: &model)
        XCTAssertEqual(model, .readyToPlay(.init(duration: 60, currentTime: 60 - 15)))
        XCTAssertEqual(commands, [.player(.setCurrentTime(45))])
    }

    func testWithPositiveElapsedTime2() {
        var model = Model.readyToPlay(.init(duration: 60, currentTime: 15))
        let commands = try! Module.update(for: .seekBack, model: &model)
        XCTAssertEqual(model, .readyToPlay(.init(duration: 60, currentTime: 0)))
        XCTAssertEqual(commands, [.player(.setCurrentTime(0))])
    }

    func testOvershoot1() {
        var model = Model.readyToPlay(.init(duration: 60, currentTime: 1))
        let commands = try! Module.update(for: .seekBack, model: &model)
        XCTAssertEqual(model, .readyToPlay(.init(duration: 60, currentTime: 0)))
        XCTAssertEqual(commands, [.player(.setCurrentTime(0))])
    }

    func testOvershoot2() {
        var model = Model.readyToPlay(.init(duration: 60, currentTime: 2))
        let commands = try! Module.update(for: .seekBack, model: &model)
        XCTAssertEqual(model, .readyToPlay(.init(duration: 60, currentTime: 0)))
        XCTAssertEqual(commands, [.player(.setCurrentTime(0))])
    }

    func testWhenUnexpected1() {
        var model = Model.waitingForURL
        XCTAssertThrowsError(try Module.update(for: .seekForward, model: &model))
    }

    func testWhenUnexpected2() {
        var model = Model.readyToLoadURL(URL.arbitrary)
        XCTAssertThrowsError(try Module.update(for: .seekForward, model: &model))
    }
    
}
