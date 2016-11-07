import XCTest
@testable import AudioBar

class PlaybackButtonTests: XCTestCase {

    // MARK: System under test

    lazy var playbackButton = PlaybackButton.make(for: .play)

    // MARK: Main

    func testType() {
        XCTAssert(playbackButton, directlyInheritsFrom: UIButton.self)
    }

    func testButtonType() {
        XCTAssertEqual(playbackButton.buttonType, .system)
    }

    // MARK: Playback action

    func testPlaybackAction1() {
        let playbackAction = PlaybackButton.PlaybackAction.play
        let playbackButton = PlaybackButton.make(for: playbackAction)
        XCTAssertEqual(playbackButton.playbackAction, playbackAction)
    }

    func testPlaybackAction2() {
        let playbackAction = PlaybackButton.PlaybackAction.pause
        let playbackButton = PlaybackButton.make(for: playbackAction)
        XCTAssertEqual(playbackButton.playbackAction, playbackAction)
    }

    // MARK: Layout constraints

    func testHeightConstraint() {
        let expectedConstraint = playbackButton.heightAnchor.constraint(greaterThanOrEqualToConstant: 44)
        XCTAssertConstraint(expectedConstraint, inView: playbackButton)
    }

    func testWidthConstraint() {
        let expectedConstraint = playbackButton.widthAnchor.constraint(greaterThanOrEqualToConstant: 44)
        XCTAssertConstraint(expectedConstraint, inView: playbackButton)
    }

}
