import XCTest
@testable import AudioBar

final class TogglePlayTests: XCTestCase {

    func testWhenReadyToLoad() {
        var model = Model.readyToLoadURL(URL.arbitrary)
        let commands = try! Module.update(for: .togglePlay, model: &model)
        XCTAssertEqual(model, .waitingForPlayerToBecomeReadyToPlayURL(URL.arbitrary))
        XCTAssertEqual(commands, [.player(.loadURL(URL.arbitrary))])
    }

    func testWhenPlaying() {
        var model = Model.readyToPlay(.init(isPlaying: true))
        let commands = try! Module.update(for: .togglePlay, model: &model)
        XCTAssertEqual(model, .readyToPlay(.init(isPlaying: false)))
        XCTAssertEqual(commands, [.player(.pause)])
    }

    func testWhenPaused() {
        var model = Model.readyToPlay(.init(isPlaying: false))
        let commands = try! Module.update(for: .togglePlay, model: &model)
        XCTAssertEqual(model, .readyToPlay(.init(isPlaying: true)))
        XCTAssertEqual(commands, [.player(.play)])
    }

    func testWhenWaitingForPlayer() {
        var model = Model.waitingForPlayerToBecomeReadyToPlayURL(URL.arbitrary)
        let commands = try! Module.update(for: .togglePlay, model: &model)
        XCTAssertEqual(model, .readyToLoadURL(URL.arbitrary))
        XCTAssertEqual(commands, [.player(.reset)])
    }

    func testWhenUnexpected() {
        var model = Model.waitingForURL
        XCTAssertThrowsError(try Module.update(for: .togglePlay, model: &model))
    }

}
