import XCTest
@testable import AudioBarApp

extension AudioBarModule {

    func testTogglePlayWhenReadyToLoad1() {
        var model = Model.readyToLoad(URL.foo)
        let commands = try! Module.update(for: .togglePlay, model: &model)
        XCTAssertEqual(model, .waitingForDuration)
        XCTAssertEqual(commands, [.player(.open(URL.foo))])
    }

    func testTogglePlayWhenReadyToLoad2() {
        var model = Model.readyToLoad(URL.bar)
        let commands = try! Module.update(for: .togglePlay, model: &model)
        XCTAssertEqual(model, .waitingForDuration)
        XCTAssertEqual(commands, [.player(.open(URL.bar))])
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

    func testTogglePlayUnexpectedly1() {
        var model = Model.waitingForURL
        XCTAssertThrowsError(try Module.update(for: .togglePlay, model: &model))
    }

    func testTogglePlayUnexpectedly2() {
        var model = Model.waitingForDuration
        XCTAssertThrowsError(try Module.update(for: .togglePlay, model: &model))
    }

}
