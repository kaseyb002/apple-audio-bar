import UIKit

enum AudioBarPlaybackState {

    case playing(remainingTime: TimeInterval)
    case paused

}

enum AudioBarAction {

    case playPause
    case seekForward
    case seekBack

}

protocol AudioBarWidgetDelegate: class {

    func audioBarWidget(audioBarWidget: AudioBarWidget, didSelectAction action: AudioBarAction)

}

protocol AudioBarWidget: class {

    weak var delegate: AudioBarWidgetDelegate? { get set }

    func setPlaybackState(playbackState: AudioBarPlaybackState)

    var stackView: UIStackView { get }

}

class DefaultAudioBarWidget: AudioBarWidget, PlayButtonWidgetDelegate {

    weak var delegate: AudioBarWidgetDelegate?

    func setPlaybackState(playbackState: AudioBarPlaybackState) {
        fatalError()
    }

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
