import XCTest
import MediaPlayer
@testable import AudioBar

class AudioBarTests: XCTestCase {

    // MARK: System under test

    let audioBar = AudioBar()

    // MARK: Main

    func testType() {
        XCTAssert(audioBar, directlyInheritsFrom: UIView.self)
    }

    func testSubviews() {
        XCTAssertEqual(audioBar.subviews, [audioBar.contentView])
    }

    func testFrame() {
        XCTAssertEqual(audioBar.frame, .zero)
    }

    // MARK: Content view

    func testContentViewType() {
        XCTAssert(audioBar.contentView, is: UIStackView.self)
    }

    func testContentViewArrangedSubviews() {
        let expectedArrangedSubviews = [audioBar.routeView, audioBar.playbackControlsView, audioBar.remainingTimeLabel]
        XCTAssertEqual(audioBar.contentView.arrangedSubviews, expectedArrangedSubviews)
    }

    func testContentViewDistribution() {
        XCTAssertEqual(audioBar.contentView.distribution, .equalSpacing)
    }

    func testContentViewIgnoresAutoresizingMask() {
        XCTAssertFalse(audioBar.contentView.translatesAutoresizingMaskIntoConstraints)
    }

    func testContentViewTopConstraint() {
        let expectedConstraint = audioBar.contentView.topAnchor.constraint(equalTo: audioBar.topAnchor)
        XCTAssertConstraint(expectedConstraint, inView: audioBar)
    }

    func testContentViewLeadingConstraint() {
        let expectedConstraint = audioBar.contentView.leadingAnchor.constraint(equalTo: audioBar.leadingAnchor)
        XCTAssertConstraint(expectedConstraint, inView: audioBar)
    }

    func testContentViewBottomConstraint() {
        let expectedConstraint = audioBar.contentView.bottomAnchor.constraint(equalTo: audioBar.bottomAnchor)
        XCTAssertConstraint(expectedConstraint, inView: audioBar)
    }

    func testContentViewTrailingConstraint() {
        let expectedConstraint = audioBar.contentView.trailingAnchor.constraint(equalTo: audioBar.trailingAnchor)
        XCTAssertConstraint(expectedConstraint, inView: audioBar)
    }

    // MARK: Route view

    func testRouteViewType() {
        XCTAssert(audioBar.routeView, is: MPVolumeView.self)
    }

    func testRouteViewNoVolumeSlider() {
        XCTAssertFalse(audioBar.routeView.showsVolumeSlider)
    }

    // MARK: Remaining time label

    func testRemainingTimeLabelType() {
        XCTAssert(audioBar.remainingTimeLabel, is: RemainingTimeLabel.self)
    }

    // MARK: Playback controls view

    func testPlaybackControlsView() {
        XCTAssert(audioBar.playbackControlsView, is: UIStackView.self)
    }

    func testPlaybackControlsViewArrangedSubviews() {
        let expectedArrangedSubviews = [audioBar.previousButton, audioBar.playButton, audioBar.nextButton]
        XCTAssertEqual(audioBar.playbackControlsView.arrangedSubviews, expectedArrangedSubviews)
    }

    // MARK: Previous button

    func testPreviousButtonType() {
        XCTAssert(audioBar.previousButton, is: UIButton.self)
    }

    func testPreviousButtonButtonType() {
        XCTAssertEqual(audioBar.previousButton.buttonType, .system)
    }

    func testPreviousButtonHeightConstraint() {
        let expectedConstraint = audioBar.previousButton.heightAnchor.constraint(greaterThanOrEqualToConstant: 44)
        XCTAssertConstraint(expectedConstraint, inView: audioBar.previousButton)
    }

    func testPreviousButtonWidthConstraint() {
        let expectedConstraint = audioBar.previousButton.widthAnchor.constraint(greaterThanOrEqualToConstant: 44)
        XCTAssertConstraint(expectedConstraint, inView: audioBar.previousButton)
    }

    // MARK: Play button

    func testPlayButtonType() {
        XCTAssert(audioBar.playButton, is: UIButton.self)
    }

    func testPlayButtonButtonType() {
        XCTAssertEqual(audioBar.playButton.buttonType, .system)
    }

    func testPlayButtonHeightConstraint() {
        let expectedConstraint = audioBar.playButton.heightAnchor.constraint(greaterThanOrEqualToConstant: 44)
        XCTAssertConstraint(expectedConstraint, inView: audioBar.playButton)
    }

    func testPlayButtonWidthConstraint() {
        let expectedConstraint = audioBar.playButton.widthAnchor.constraint(greaterThanOrEqualToConstant: 44)
        XCTAssertConstraint(expectedConstraint, inView: audioBar.playButton)
    }

    // MARK: Next button

    func testNextButtonType() {
        XCTAssert(audioBar.nextButton, is: UIButton.self)
    }

    func testNextButtonButtonType() {
        XCTAssertEqual(audioBar.nextButton.buttonType, .system)
    }

    func testNextButtonHeightConstraint() {
        let expectedConstraint = audioBar.nextButton.heightAnchor.constraint(greaterThanOrEqualToConstant: 44)
        XCTAssertConstraint(expectedConstraint, inView: audioBar.nextButton)
    }

    func testNextButtonWidthConstraint() {
        let expectedConstraint = audioBar.nextButton.widthAnchor.constraint(greaterThanOrEqualToConstant: 44)
        XCTAssertConstraint(expectedConstraint, inView: audioBar.nextButton)
    }

}
