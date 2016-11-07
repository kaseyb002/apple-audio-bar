import XCTest
@testable import AudioBar

class PlaybackControlsViewTests: XCTestCase {

    // MARK: System under test

    let playbackControlsView = PlaybackControlsView()

    // MARK: Main

    func testType() {
        XCTAssert(playbackControlsView, directlyInheritsFrom: UIStackView.self)
    }

    func testFrame() {
        XCTAssertEqual(playbackControlsView.frame, .zero)
    }

    func testArrangedSubviews() {
        let expectedArrangedSubviews = [playbackControlsView.previousButton, playbackControlsView.playButton, playbackControlsView.nextButton]
        XCTAssertEqual(playbackControlsView.arrangedSubviews, expectedArrangedSubviews)
    }

    // MARK: Previous button

    func testPreviousButtonType() {
        XCTAssert(playbackControlsView.previousButton, is: PlaybackButton.self)
    }

    func testPreviousButtonPlaybackAction() {
        XCTAssertEqual(playbackControlsView.previousButton.playbackAction, .previous)
    }

    // MARK: Play button

    func testPlayButtonType() {
        XCTAssert(playbackControlsView.playButton, is: PlaybackButton.self)
    }

    func testPlayButtonPlaybackAction() {
        XCTAssertEqual(playbackControlsView.playButton.playbackAction, .play)
    }

    // MARK: Next button

    func testNextButtonType() {
        XCTAssert(playbackControlsView.nextButton, is: PlaybackButton.self)
    }

    func testNextButtonPlaybackAction() {
        XCTAssertEqual(playbackControlsView.nextButton.playbackAction, .next)
    }

}
