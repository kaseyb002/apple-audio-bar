import XCTest
@testable import AudioBar

final class PlayerDidPlayToEndTests: XCTestCase {

    func test() {
        var model = Model.readyToPlay(.init(isPlaying: true, duration: 60, currentTime: 0))
        let commands = try! Module.update(for: .playerDidPlayToEnd, model: &model)
        XCTAssertEqual(model, .readyToPlay(.init(isPlaying: false, duration: 60, currentTime: 60)))
        XCTAssertTrue(commands.isEmpty)
    }

    func testWhenUnexpected1() {
        var model = Model.readyToPlay(.init(isPlaying: false))
        XCTAssertThrowsError(try Module.update(for: .playerDidPlayToEnd, model: &model))
    }

    func testWhenUnexpected2() {
        var model = Model.waitingForURL
        XCTAssertThrowsError(try Module.update(for: .playerDidPlayToEnd, model: &model))
    }

    func testWhenUnexpected3() {
        var model = Model.readyToLoadURL(URL.arbitrary)
        XCTAssertThrowsError(try Module.update(for: .playerDidPlayToEnd, model: &model))
    }

    func testWhenUnexpected4() {
        var model = Model.waitingForPlayerToBecomeReadyToPlayURL(URL.arbitrary)
        XCTAssertThrowsError(try Module.update(for: .playerDidPlayToEnd, model: &model))
    }
    
}
