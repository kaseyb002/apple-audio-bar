import XCTest
@testable import AudioBar

class AudioBarTests: XCTestCase {

    func testAudioBarType() {
        let audioBar = AudioBar()
        XCTAssert(audioBar as Any is UIView)
    }
    
}
