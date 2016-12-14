import XCTest
@testable import AudioBarApp

extension AudioBarModuleTests {

    func testLoadTrack1() {
        var model = Model.waitingForURL
        let commands = try! Module.update(for: .prepareToLoad(URL.foo), model: &model)
        XCTAssertEqual(model, .readyToLoad(URL.foo))
        XCTAssertTrue(commands.isEmpty)
    }

    func testLoadTrack2() {
        var model = Model.waitingForURL
        let commands = try! Module.update(for: .prepareToLoad(URL.bar), model: &model)
        XCTAssertEqual(model, .readyToLoad(URL.bar))
        XCTAssertTrue(commands.isEmpty)
    }

    // TODO: How do we handle this?
    func testLoadTrackUnexpectedly() {}

}
