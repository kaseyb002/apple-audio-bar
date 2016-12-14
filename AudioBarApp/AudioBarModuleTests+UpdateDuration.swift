import XCTest
@testable import AudioBarApp

extension AudioBarModuleTests {

    func testPlayerDidUpdateDuration1() {
        var model = Model.waitingForDuration
        let commands = try! Module.update(for: .playerDidUpdateDuration(1), model: &model)
        XCTAssertEqual(model, .readyToPlay(.init(isPlaying: true, duration: 1, currentTime: 0)))
        XCTAssertEqual(commands, [.player(.play)])
    }

    func testPlayerDidUpdateDuration2() {
        var model = Model.waitingForDuration
        let commands = try! Module.update(for: .playerDidUpdateDuration(2), model: &model)
        XCTAssertEqual(model, .readyToPlay(.init(isPlaying: true, duration: 2, currentTime: 0)))
        XCTAssertEqual(commands, [.player(.play)])
    }

    func testplayerDidUpdateDurationUnexpectedly1() {
        var model = Model.waitingForURL
        XCTAssertThrowsError(try Module.update(for: .playerDidUpdateDuration(1), model: &model))
    }

    func testplayerDidUpdateDurationUnexpectedly2() {
        var model = Model.readyToLoad(URL.foo)
        XCTAssertThrowsError(try Module.update(for: .playerDidUpdateDuration(1), model: &model))
    }

    func testplayerDidUpdateDurationUnexpectedly3() {
        var model = Model.readyToPlay(.init())
        XCTAssertThrowsError(try Module.update(for: .playerDidUpdateDuration(1), model: &model))
    }
    
}
