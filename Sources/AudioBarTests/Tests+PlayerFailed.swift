import XCTest
@testable import AudioBar

extension Tests {

    func testPlayerDidFailToBecomeReady() {
        var model = Model.waitingForPlayerToBecomeReadyToPlayURL(URL.arbitrary)
        let commands = try! Module.update(for: .playerDidFailToBecomeReady, model: &model)
        XCTAssertEqual(model, .readyToLoadURL(URL.arbitrary))
        XCTAssertEqual(commands, [.player(.reset), .showAlert(text: "Unable to load media", button: "OK")])
    }

    func testPlayerDidFailToBecomeReadyUnexpectedly1() {
        var model = Model.waitingForURL
        XCTAssertThrowsError(try Module.update(for: .playerDidFailToBecomeReady, model: &model))
    }

    func testPlayerDidFailToBecomeReadyUnexpectedly2() {
        var model = Model.readyToLoadURL(URL.arbitrary)
        XCTAssertThrowsError(try Module.update(for: .playerDidFailToBecomeReady, model: &model))
    }

    func testPlayerDidFailToBecomeReadyUnexpectedly3() {
        var model = Model.readyToPlay(.init())
        XCTAssertThrowsError(try Module.update(for: .playerDidFailToBecomeReady, model: &model))
    }
    
}
