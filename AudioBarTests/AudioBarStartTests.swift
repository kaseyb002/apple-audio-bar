import XCTest
import Elm

@testable import AudioBar

class AudioBarStartTests: XCTestCase, Tests {

    typealias Module = AudioBarModule
    let failureReporter = XCTFail

    func testDefaultModel() {
        let model = expectModel(loading: .init())
        expect(model, .waitingForURL)
    }
    
}
