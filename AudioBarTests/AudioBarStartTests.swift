import XCTest
import Elm

@testable import AudioBar

class AudioBarStartTests: XCTestCase, StartTests {

    var fixture = StartFixture<AudioBarModule>()
    let failureReporter = XCTFail

    func testDefaultModel() {
        flags = .init()
        expect(model, .waitingForURL)
    }
    
}
