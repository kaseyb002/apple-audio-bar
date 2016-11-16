import UIKit

enum AudioBarState {

    case playing(remainingTime: TimeInterval)
    case paused

}

enum AudioBarAction {

    case previous
    case play
    case pause
    case next

}

protocol AudioBarWidget: class {

    func setState(state: AudioBarState)

    typealias OnAction = (AudioBarAction) -> Void
    var onAction: OnAction? { get set }

    var stackView: UIStackView { get }

}

class DefaultAudioBarWidget: AudioBarWidget, PlayButtonWidgetDelegate {

    func setState(state: AudioBarState) {
        fatalError()
    }

    var onAction: AudioBarWidget.OnAction? = { _ in fatalError() }

    let playButtonWidget: PlayButtonWidget
    let remainingTimeWidget: RemainingTimeWidget

    var stackView = UIStackView()

    init(playButtonWidget: PlayButtonWidget = DefaultPlayButtonWidget(), remainingTimeWidget: RemainingTimeWidget = DefaultRemainingTimeWidget()) {
        self.playButtonWidget = playButtonWidget
        self.remainingTimeWidget = remainingTimeWidget
        didInit()
    }

    private func didInit() {
        stackView.addArrangedSubview(playButtonWidget.button)
        stackView.addArrangedSubview(remainingTimeWidget.label)
        playButtonWidget.delegate = self
    }

    func playButtonDidReceiveTap(_ playButtonWidget: PlayButtonWidget) {

    }
    
}
