import XCTest
import MediaPlayer
@testable import AudioBar

class AudioBarViewTests: XCTestCase {

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
        XCTAssert(audioBar.remainingTimeLabel, is: UILabel.self)
    }

    func testRemainingTimeLabelText1() {
        let remainingTimeText = "A"
        let remainingTimeFormatterStub = RemainingTimeFormatterStub(cannedOutput: remainingTimeText)
        audioBar.remainingTimeFormatter = remainingTimeFormatterStub
        audioBar.remainingTime = 0
        XCTAssertEqual(audioBar.remainingTimeLabel.text, remainingTimeText)
    }

    func testRemainingTimeLabelText2() {
        let remainingTimeText = "B"
        let remainingTimeFormatterStub = RemainingTimeFormatterStub(cannedOutput: remainingTimeText)
        audioBar.remainingTimeFormatter = remainingTimeFormatterStub
        audioBar.remainingTime = 0
        XCTAssertEqual(audioBar.remainingTimeLabel.text, remainingTimeText)
    }

    func testRemainingTimeLabelTextReset() {
        audioBar.remainingTimeLabel.text = "A"
        audioBar.remainingTime = nil
        XCTAssertNil(audioBar.remainingTimeLabel.text)
    }

    // MARK: Remaining time

    func testRemainingTimeType() {
        XCTAssert(audioBar.remainingTime, is: Optional<TimeInterval>.self)
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

    // MARK: Play button

    func testPlayButtonType() {
        XCTAssert(audioBar.playButton, is: UIButton.self)
    }

    func testPlayButtonButtonType() {
        XCTAssertEqual(audioBar.playButton.buttonType, .system)
    }

    // MARK: Next button

    func testNextButtonType() {
        XCTAssert(audioBar.nextButton, is: UIButton.self)
    }

    func testNextButtonButtonType() {
        XCTAssertEqual(audioBar.nextButton.buttonType, .system)
    }

    // MARK: Remaining time formatter

    func testRemainingTimeFormatterType() {
        XCTAssert(audioBar.remainingTimeFormatter as Any is RemainingTimeFormatting)
    }

    func testRemainingTimeFormatterIdentity() {
        XCTAssert(audioBar.remainingTimeFormatter === audioBar.remainingTimeFormatter)
    }

    func testRemainingTimeFormatterAllowedUnits() {
        let remainingTimeFormatter = audioBar.remainingTimeFormatter as! DateComponentsFormatter
        XCTAssertEqual(remainingTimeFormatter.allowedUnits, [.minute, .second])
    }

    func testRemainingTimeFormatterInput1() {
        let spy = RemainingTimeFormatterSpy()
        audioBar.remainingTimeFormatter = spy
        audioBar.remainingTime = 1
        XCTAssertEqual(spy.capturedTimeIntervals, [1])
    }

    func testRemainingTimeFormatterInput2() {
        let spy = RemainingTimeFormatterSpy()
        audioBar.remainingTimeFormatter = spy
        audioBar.remainingTime = 2
        XCTAssertEqual(spy.capturedTimeIntervals, [2])
    }

}

private class RemainingTimeFormatterSpy: RemainingTimeFormatting {

    var capturedTimeIntervals: [TimeInterval] = []

    func string(from timeInterval: TimeInterval) -> String? {
        capturedTimeIntervals.append(timeInterval)
        return nil
    }

}

private class RemainingTimeFormatterStub: RemainingTimeFormatting {

    let cannedOutput: String?

    init(cannedOutput: String?) {
        self.cannedOutput = cannedOutput
    }

    func string(from timeInterval: TimeInterval) -> String? {
        return cannedOutput
    }

}
