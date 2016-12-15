import XCTest
@testable import AudioBar

extension Tests {

    func testDefaultModel() {
        let model = Model()
        XCTAssertEqual(model, .waitingForURL)
    }

}
