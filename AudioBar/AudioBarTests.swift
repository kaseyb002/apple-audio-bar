import XCTest
import MediaPlayer
@testable import AudioBar

class AudioBarTests: XCTestCase {

    // MARK: System under test

    let audioBar = AudioBar()

    // MARK: Main

    func testType() {
        XCTAssert(audioBar, directlyInheritsFrom: UIStackView.self)
    }

    func testFrame() {
        XCTAssertEqual(audioBar.frame, .zero)
    }

    // MARK: Content view

    func testArrangedSubviews() {
        let expectedArrangedSubviews = [audioBar.routeView, audioBar.playbackControlsView, audioBar.remainingTimeLabel]
        XCTAssertEqual(audioBar.arrangedSubviews, expectedArrangedSubviews)
    }

    func testDistribution() {
        XCTAssertEqual(audioBar.distribution, .equalSpacing)
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
        XCTAssert(audioBar.playbackControlsView, is: PlaybackControlsView.self)
    }

}
