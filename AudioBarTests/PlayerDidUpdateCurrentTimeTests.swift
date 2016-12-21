import XCTest
@testable import AudioBar

final class PlayerDidUpdateCurrentTimeTests: XCTestCase {

    func test1() {
        var model = Model.readyToPlay(.init(currentTime: 0))
        let commands = try! Module.update(for: .playerDidUpdateCurrentTime(1), model: &model)
        XCTAssertEqual(model, .readyToPlay(.init(currentTime: 1)))
        XCTAssertTrue(commands.isEmpty)
    }

    func test2() {
        var model = Model.readyToPlay(.init(currentTime: 1))
        let commands = try! Module.update(for: .playerDidUpdateCurrentTime(2), model: &model)
        XCTAssertEqual(model, .readyToPlay(.init(currentTime: 2)))
        XCTAssertTrue(commands.isEmpty)
    }

    func testWhenUnexpected1() {
        var model = Model.waitingForURL
        XCTAssertThrowsError(try Module.update(for: .playerDidUpdateCurrentTime(0), model: &model))
    }

    func testWhenUnexpected2() {
        var model = Model.readyToLoadURL(URL.arbitrary)
        XCTAssertThrowsError(try Module.update(for: .playerDidUpdateCurrentTime(0), model: &model))
    }

    func testWhenUnexpected3() {
        var model = Model.waitingForPlayerToBecomeReadyToPlayURL(URL.arbitrary)
        XCTAssertThrowsError(try Module.update(for: .playerDidUpdateCurrentTime(0), model: &model))
    }

}
