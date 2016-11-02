import XCTest
@testable import AudioBar

class AudioBarControllerTests: XCTestCase {

    func testAudioBarType() {
        let audioBar = AudioBarController()
        XCTAssert(audioBar as Any is UIViewController)
    }
    
}
