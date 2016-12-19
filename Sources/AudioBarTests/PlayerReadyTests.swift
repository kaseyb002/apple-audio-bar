import XCTest
@testable import AudioBar

final class PlayerReadyTests: XCTestCase {

    func test() {
        var model = Model.waitingForPlayerToBecomeReadyToPlayURL(URL.arbitrary)
        let commands = try! Module.update(for: .playerDidBecomeReadyToPlay(withDuration: 1), model: &model)
        XCTAssertEqual(model, .readyToPlay(.init(isPlaying: true, duration: 1, currentTime: nil)))
        XCTAssertEqual(commands, [.player(.play)])
    }

    func testWhenUnexpected1() {
        var model = Model.waitingForURL
        XCTAssertThrowsError(try Module.update(for: .playerDidBecomeReadyToPlay(withDuration: 0), model: &model))
    }

    func testWhenUnexpected2() {
        var model = Model.readyToLoadURL(URL.arbitrary)
        XCTAssertThrowsError(try Module.update(for: .playerDidBecomeReadyToPlay(withDuration: 0), model: &model))
    }

    func testWhenUnexpected3() {
        var model = Model.readyToPlay(.init())
        XCTAssertThrowsError(try Module.update(for: .playerDidBecomeReadyToPlay(withDuration: 0), model: &model))
    }
    
}
