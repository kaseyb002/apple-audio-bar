import XCTest
@testable import AudioBar

final class PlayerFailedTests: XCTestCase {

    func test() {
        var model = Model.waitingForPlayerToBecomeReadyToPlayURL(URL.arbitrary)
        let commands = try! Module.update(for: .playerDidFailToBecomeReady, model: &model)
        XCTAssertEqual(model, .readyToLoadURL(URL.arbitrary))
        XCTAssertEqual(commands, [.player(.reset), .showAlert(text: "Unable to load media", button: "OK")])
    }

    func testWhenUnexpected1() {
        var model = Model.waitingForURL
        XCTAssertThrowsError(try Module.update(for: .playerDidFailToBecomeReady, model: &model))
    }

    func testWhenUnexpected2() {
        var model = Model.readyToLoadURL(URL.arbitrary)
        XCTAssertThrowsError(try Module.update(for: .playerDidFailToBecomeReady, model: &model))
    }

    func testWhenUnexpected3() {
        var model = Model.readyToPlay(.init())
        XCTAssertThrowsError(try Module.update(for: .playerDidFailToBecomeReady, model: &model))
    }
    
}
