import XCTest

@testable import AudioBar

class PlayButtonWidgetTests: XCTestCase {

    // MARK: System under test

    lazy var playButtonWidget = DefaultPlayButtonWidget()

    // MARK: Main

    func testInterface() {
        XCTAssertTrue(playButtonWidget as Any is PlayButtonWidget)
    }

    // MARK: Button

    func testButtonType() {
        XCTAssertTrue(playButtonWidget.button as Any is UIButton)
    }

    func testButtonIsConstant() {
        XCTAssertTrue(playButtonWidget.button === playButtonWidget.button)
    }

    func testButtonButtonType() {
        XCTAssertEqual(playButtonWidget.button.buttonType, .system)
    }

    func testButtonTitle() {
        XCTAssertEqual(playButtonWidget.button.title(for: .normal), "play")
    }

    func testButtonTitleWhenStateChanges1() {
        playButtonWidget.button.setTitle(nil, for: .normal)
        playButtonWidget.setState(.playing)
        XCTAssertEqual(playButtonWidget.button.title(for: .normal), "pause")
    }

    func testButtonTitleWhenStateChanges2() {
        playButtonWidget.button.setTitle(nil, for: .normal)
        playButtonWidget.setState(.paused)
        XCTAssertEqual(playButtonWidget.button.title(for: .normal), "play")
    }

    func testButtonAction() {
        let actions = playButtonWidget.button.actions(forTarget: playButtonWidget, forControlEvent: .touchUpInside)!
        let expectedAction = String(describing: #selector(DefaultPlayButtonWidget.buttonDidReceiveTouchUpInside))
        XCTAssertEqual(actions, [expectedAction])
    }

    // MARK: Delegate

    func testDelegateType() {
        XCTAssert(playButtonWidget.delegate, is: Optional<PlayButtonWidgetDelegate>.self)
    }

    func testDelegateIsCalled() {
        class PlayButtonWidgetDelegateMock: PlayButtonWidgetDelegate {
            var capturedPlayButtonWidgets: [PlayButtonWidget] = []
            func playButtonDidReceiveTap(_ playButtonWidget: PlayButtonWidget) {
                capturedPlayButtonWidgets.append(playButtonWidget)
            }
        }
        let playButtonWidgetDelegateMock = PlayButtonWidgetDelegateMock()
        playButtonWidget.delegate = playButtonWidgetDelegateMock
        playButtonWidget.buttonDidReceiveTouchUpInside()
        XCTAssertEqual(playButtonWidgetDelegateMock.capturedPlayButtonWidgets, [playButtonWidget])
    }

}
