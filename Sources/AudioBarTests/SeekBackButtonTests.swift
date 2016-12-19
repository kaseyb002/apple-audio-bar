import XCTest
@testable import AudioBar

final class SeekBackButtonTests: XCTestCase {

    func testWithElapsedTimeZero() {
        let model = Model.readyToPlay(.init(duration: 60, currentTime: 0))
        let view = Module.view(for: model)
        XCTAssertFalse(view.isSeekBackButtonEnabled)
    }

    func testWithPositiveElapsedTime() {
        let model = Model.readyToPlay(.init(duration: 60, currentTime: 0.01))
        let view = Module.view(for: model)
        XCTAssertTrue(view.isSeekBackButtonEnabled)
    }

    func testWhenUnexpected1() {
        var model = Model.waitingForURL
        XCTAssertThrowsError(try Module.update(for: .seekBack, model: &model))
    }

    func testWhenUnexpected2() {
        var model = Model.readyToLoadURL(URL.arbitrary)
        XCTAssertThrowsError(try Module.update(for: .seekBack, model: &model))
    }
    
}
