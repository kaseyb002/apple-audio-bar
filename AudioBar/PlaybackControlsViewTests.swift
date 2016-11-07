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
        XCTAssert(playbackControlsView.previousButton, is: UIButton.self)
    }

    func testPreviousButtonButtonType() {
        XCTAssertEqual(playbackControlsView.previousButton.buttonType, .system)
    }

    func testPreviousButtonHeightConstraint() {
        let expectedConstraint = playbackControlsView.previousButton.heightAnchor.constraint(greaterThanOrEqualToConstant: 44)
        XCTAssertConstraint(expectedConstraint, inView: playbackControlsView.previousButton)
    }

    func testPreviousButtonWidthConstraint() {
        let expectedConstraint = playbackControlsView.previousButton.widthAnchor.constraint(greaterThanOrEqualToConstant: 44)
        XCTAssertConstraint(expectedConstraint, inView: playbackControlsView.previousButton)
    }

    // MARK: Play button

    func testPlayButtonType() {
        XCTAssert(playbackControlsView.playButton, is: UIButton.self)
    }

    func testPlayButtonButtonType() {
        XCTAssertEqual(playbackControlsView.playButton.buttonType, .system)
    }

    func testPlayButtonHeightConstraint() {
        let expectedConstraint = playbackControlsView.playButton.heightAnchor.constraint(greaterThanOrEqualToConstant: 44)
        XCTAssertConstraint(expectedConstraint, inView: playbackControlsView.playButton)
    }

    func testPlayButtonWidthConstraint() {
        let expectedConstraint = playbackControlsView.playButton.widthAnchor.constraint(greaterThanOrEqualToConstant: 44)
        XCTAssertConstraint(expectedConstraint, inView: playbackControlsView.playButton)
    }

    // MARK: Next button

    func testNextButtonType() {
        XCTAssert(playbackControlsView.nextButton, is: UIButton.self)
    }

    func testNextButtonButtonType() {
        XCTAssertEqual(playbackControlsView.nextButton.buttonType, .system)
    }

    func testNextButtonHeightConstraint() {
        let expectedConstraint = playbackControlsView.nextButton.heightAnchor.constraint(greaterThanOrEqualToConstant: 44)
        XCTAssertConstraint(expectedConstraint, inView: playbackControlsView.nextButton)
    }

    func testNextButtonWidthConstraint() {
        let expectedConstraint = playbackControlsView.nextButton.widthAnchor.constraint(greaterThanOrEqualToConstant: 44)
        XCTAssertConstraint(expectedConstraint, inView: playbackControlsView.nextButton)
    }

}
