import XCTest
@testable import AudioBar

final class SeekBackButtonTests: XCTestCase {

    func testWithNoElapsedTime() {
        let model = Model.readyToPlay(.init(currentTime: nil))
        let view = Module.view(for: model)
        XCTAssertFalse(view.isSeekBackButtonEnabled)
    }

    func testWithZeroElapsedTime() {
        let model = Model.readyToPlay(.init(duration: 60, currentTime: 0))
        let view = Module.view(for: model)
        XCTAssertFalse(view.isSeekBackButtonEnabled)
    }

    func testWithPositiveElapsedTime1() {
        let model = Model.readyToPlay(.init(duration: 60, currentTime: 0.01))
        let view = Module.view(for: model)
        XCTAssertTrue(view.isSeekBackButtonEnabled)
    }

    func testWithPositiveElapsedTime2() {
        let model = Model.readyToPlay(.init(duration: 60, currentTime: 0.02))
        let view = Module.view(for: model)
        XCTAssertTrue(view.isSeekBackButtonEnabled)
    }
    
}
