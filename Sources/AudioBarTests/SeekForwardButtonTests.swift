import XCTest
@testable import AudioBar

final class SeekForwardButtonTests: XCTestCase {

    func testWhenNotAtEnd1() {
        let model = Model.readyToPlay(.init(duration: 1, currentTime: 0.99))
        let view = Module.view(for: model)
        XCTAssertTrue(view.isSeekForwardButtonEnabled)
    }

    func testWhenNotAtEnd2() {
        let model = Model.readyToPlay(.init(duration: 2, currentTime: 1.99))
        let view = Module.view(for: model)
        XCTAssertTrue(view.isSeekForwardButtonEnabled)
    }

    func testWhenAtEnd1() {
        let model = Model.readyToPlay(.init(duration: 1, currentTime: 1))
        let view = Module.view(for: model)
        XCTAssertFalse(view.isSeekForwardButtonEnabled)
    }

    func testWhenAtEnd2() {
        let model = Model.readyToPlay(.init(duration: 2, currentTime: 2))
        let view = Module.view(for: model)
        XCTAssertFalse(view.isSeekForwardButtonEnabled)
    }
    
}
