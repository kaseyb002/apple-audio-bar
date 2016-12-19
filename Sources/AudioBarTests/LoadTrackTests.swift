import XCTest
@testable import AudioBar

final class LoadTrackTests: XCTestCase {

    func test() {
        var model = Model.waitingForURL
        let commands = try! Module.update(for: .prepareToLoad(URL.arbitrary), model: &model)
        XCTAssertEqual(model, .readyToLoadURL(URL.arbitrary))
        XCTAssertTrue(commands.isEmpty)
    }

}
