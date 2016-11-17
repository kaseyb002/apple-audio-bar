
import XCTest
@testable import AudioBar

class DefaultAudioBarWidgetTests: XCTestCase {

    // MARK: System under test

    lazy var audioBarWidget: DefaultAudioBarWidget = DefaultAudioBarWidget(
        playButtonWidget: DefaultPlayButtonWidgetDouble(),
        seekWidget: DefaultSeekWidgetDouble(),
        remainingTimeWidget: DefaultRemainingTimeWidgetDouble()
    )

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
        let audioBarWidget = DefaultAudioBarWidget(playButtonWidget: playButtonWidgetDummy, seekWidget: DefaultSeekWidgetDouble(), remainingTimeWidget: DefaultRemainingTimeWidgetDouble())
        XCTAssertTrue(audioBarWidget.playButtonWidget === playButtonWidgetDummy)
    }

    func testPlayButtonDelegate() {
        class PlayButtonWidgetMock: PlayButtonWidgetDouble {
            var delegate: PlayButtonWidgetDelegate?
        }
        let playButtonWidgetMock = PlayButtonWidgetMock()
        let audioBarWidget = DefaultAudioBarWidget(playButtonWidget: playButtonWidgetMock, seekWidget: DefaultSeekWidgetDouble(), remainingTimeWidget: DefaultRemainingTimeWidgetDouble())
        XCTAssertEqual(playButtonWidgetMock.delegate, audioBarWidget)
    }

    func testPlayButtonAction() {
        class AudioBarWidgetDelegateMock: AudioBarWidgetDelegate {
            var capturedAudioBarWidgets: [AudioBarWidget] = []
            var capturedActions: [AudioBarWidgetAction] = []
            func audioBarWidget(audioBarWidget: AudioBarWidget, didSelectAction action: AudioBarWidgetAction) {
                capturedAudioBarWidgets.append(audioBarWidget)
                capturedActions.append(action)
            }
        }
        let audioBarWidgetDelegateMock = AudioBarWidgetDelegateMock()
        audioBarWidget.delegate = audioBarWidgetDelegateMock
        audioBarWidget.playButtonDidReceiveTap(audioBarWidget.playButtonWidget)
        XCTAssertEqual(audioBarWidgetDelegateMock.capturedAudioBarWidgets, [audioBarWidget])
        XCTAssertEqual(audioBarWidgetDelegateMock.capturedActions, [.playPause])
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
        let audioBarWidget = DefaultAudioBarWidget(playButtonWidget: DefaultPlayButtonWidgetDouble(), seekWidget: DefaultSeekWidgetDouble(), remainingTimeWidget: remainingTimeWidgetDummy)
        XCTAssertTrue(audioBarWidget.remainingTimeWidget === remainingTimeWidgetDummy)
    }

    func testRemainingTimeWidgetViewInstalled() {

        class PlayButtonWidgetMock: PlayButtonWidgetDouble {
            let view = UIView()
        }

        class SeekWidgetMock: SeekWidgetDouble {

            let viewForBack = UIView()
            let viewForForward = UIView()

            func view(for action: SeekWidgetAction) -> UIView {
                switch action {
                case .back: return viewForBack
                case .forward: return viewForForward
                }
            }

        }

        class RemainingTimeWidgetMock: RemainingTimeWidgetDouble {
            let view = UIView()
        }

        let playButtonWidgetMock = PlayButtonWidgetMock()
        let seekWidgetMock = SeekWidgetMock()
        let remainingTimeWidgetMock = RemainingTimeWidgetMock()
        let audioBarWidget = DefaultAudioBarWidget(playButtonWidget: playButtonWidgetMock, seekWidget: seekWidgetMock, remainingTimeWidget: remainingTimeWidgetMock)
        XCTAssertEqual(audioBarWidget.stackView.arrangedSubviews, [playButtonWidgetMock.view, remainingTimeWidgetMock.view])
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

    // MARK: View

    func testView() {
        XCTAssertEqual(audioBarWidget.view, audioBarWidget.stackView)
    }

    // MARK: Presentable

    func testPresentableUpdatesRemainingTimeWidget1() { testPresentableUpdatesRemainingTimeWidget(withRemainingTime: 1) }
    func testPresentableUpdatesRemainingTimeWidget2() { testPresentableUpdatesRemainingTimeWidget(withRemainingTime: 2) }

    func testPresentableUpdatesRemainingTimeWidget(withRemainingTime remainingTime: TimeInterval, file: StaticString = #file, line: UInt = #line) {

        struct AudioBarWidgetPresentableMock: AudioBarWidgetPresentableDouble {
            let remainingTime: TimeInterval
        }

        class RemainingTimeWidgetMock: RemainingTimeWidgetDouble {
            var capturedRemainingTimes: [TimeInterval?] = []
            func showRemainingTime(_ remainingTime: TimeInterval?) {
                capturedRemainingTimes.append(remainingTime)
            }
        }

        let remainingTimeWidgetMock = RemainingTimeWidgetMock()
        let audioBarWidget = DefaultAudioBarWidget(playButtonWidget: DefaultPlayButtonWidgetDouble(), seekWidget: DefaultSeekWidgetDouble(), remainingTimeWidget: remainingTimeWidgetMock)
        let audioBarWidgetPresentableMock = AudioBarWidgetPresentableMock(remainingTime: remainingTime)
        audioBarWidget.configure(with: audioBarWidgetPresentableMock)
        XCTAssertEqual(remainingTimeWidgetMock.capturedRemainingTimes, [remainingTime])

    }

    func testPresentableUpdatesPlayButtonWidget1() { testPresentableUpdatesPlayButtonWidget(withIsPlaying: true) }
    func testPresentableUpdatesPlayButtonWidget2() { testPresentableUpdatesPlayButtonWidget(withIsPlaying: false) }

    func testPresentableUpdatesPlayButtonWidget(withIsPlaying isPlaying: Bool, file: StaticString = #file, line: UInt = #line) {

        struct AudioBarWidgetPresentableMock: AudioBarWidgetPresentableDouble {
            let isPlaying: Bool
        }

        class PlayButtonWidgetMock: PlayButtonWidgetDouble {
            var capturedSetPlaying: [Bool] = []
            func setPlaying(_ playing: Bool) {
                capturedSetPlaying.append(playing)
            }
        }

        let playButtonWidgetMock = PlayButtonWidgetMock()
        let audioBarWidget = DefaultAudioBarWidget(playButtonWidget: playButtonWidgetMock, seekWidget: DefaultSeekWidgetDouble(), remainingTimeWidget: DefaultRemainingTimeWidgetDouble())
        let audioBarWidgetPresentableMock = AudioBarWidgetPresentableMock(isPlaying: isPlaying)
        audioBarWidget.configure(with: audioBarWidgetPresentableMock)
        XCTAssertEqual(playButtonWidgetMock.capturedSetPlaying, [isPlaying])

    }

    // MARK: Seek back button

//    func testSeekWidgetType() {
//        class SeekWidgetMock: SeekWidgetDouble {}
//        let seekWidgetMock = SeekWidgetMock()
//        let audioBarWidget = DefaultAudioBarWidget(seekWidget: seekWidgetMock)
//        XCTAssertEqual(audioBarWidget.seekWidget, seekWidgetMock)
//    }

    // MARK: Seek forward button

}
