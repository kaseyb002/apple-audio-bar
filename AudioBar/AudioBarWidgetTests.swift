
import XCTest
@testable import AudioBar

class DefaultAudioBarWidgetTests: XCTestCase {

    // MARK: System under test

    lazy var audioBarWidget: DefaultAudioBarWidget = DefaultAudioBarWidget()

    // MARK: Main

    func testInterface() {
        XCTAssertTrue(audioBarWidget as Any is AudioBarWidget)
    }

    // MARK: Play button widget

    func testPlayButtonWidgetType() {
        XCTAssertTrue(audioBarWidget.playButtonWidget as Any is PlayButtonWidget)
    }

    func testPlayButtonWidgetIsConstant() {
        XCTAssertConstant(audioBarWidget.playButtonWidget)
    }

    func testPlayButtonWidgetInjection() {
        class PlayButtonWidgetDummy: PlayButtonWidgetDouble {}
        let playButtonWidgetDummy = PlayButtonWidgetDummy()
        let audioBarWidget = DefaultAudioBarWidget(playButtonWidget: playButtonWidgetDummy)
        XCTAssertTrue(audioBarWidget.playButtonWidget === playButtonWidgetDummy)
    }

    func testPlayButtonDelegate() {
        XCTAssertEqual(audioBarWidget.playButtonWidget.delegate, audioBarWidget)
    }

    // MARK: Remaining time widget

    func testRemainingTimeWidgetType() {
        XCTAssertTrue(audioBarWidget.remainingTimeWidget as Any is RemainingTimeWidget)
    }

    func testRemainingTimeWidgetIsConstant() {
        XCTAssertConstant(audioBarWidget.remainingTimeWidget)
    }

    func testRemainingTimeWidgetInjection() {
        class RemainingTimeWidgetDummy: RemainingTimeWidgetDouble {}
        let remainingTimeWidgetDummy = RemainingTimeWidgetDummy()
        let audioBarWidget = DefaultAudioBarWidget(remainingTimeWidget: remainingTimeWidgetDummy)
        XCTAssertTrue(audioBarWidget.remainingTimeWidget === remainingTimeWidgetDummy)
    }

    // MARK: Stack view

    func testStackViewType() {
        XCTAssert(audioBarWidget.stackView, is: UIStackView.self)
    }

    func testStackViewIsConstant() {
        XCTAssertConstant(audioBarWidget.stackView)
    }

    func testStackViewArrangedSubviews() {
        XCTAssertEqual(audioBarWidget.stackView.arrangedSubviews, [audioBarWidget.playButtonWidget.button, audioBarWidget.remainingTimeWidget.label])
    }

}
