import XCTest
@testable import AudioBar

final class DefaultModelTests: XCTestCase {

    func test() {
        let model = Model()
        XCTAssertEqual(model, .waitingForURL)
    }

}
