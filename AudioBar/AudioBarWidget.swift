import UIKit

enum AudioBarWidgetAction {

    case playPause
    case seekForward
    case seekBack

}

protocol AudioBarWidgetDelegate: class {

    func audioBarWidget(audioBarWidget: AudioBarWidget, didSelectAction action: AudioBarWidgetAction)

}

protocol AudioBarWidget: class {

    weak var delegate: AudioBarWidgetDelegate? { get set }

    func configure(with presentable: AudioBarWidgetPresentable)

    var view: UIView { get }

}

class DefaultAudioBarWidget: AudioBarWidget, PlayButtonWidgetDelegate {

    weak var delegate: AudioBarWidgetDelegate?

    let playButtonWidget: PlayButtonWidget
    let seekWidget: SeekWidget
    let remainingTimeWidget: RemainingTimeWidget

    var stackView = UIStackView()

    init(playButtonWidget: PlayButtonWidget, seekWidget: SeekWidget, remainingTimeWidget: RemainingTimeWidget) {
        self.playButtonWidget = playButtonWidget
        self.seekWidget = seekWidget
        self.remainingTimeWidget = remainingTimeWidget
        didInit()
    }

    private func didInit() {
        stackView.addArrangedSubview(playButtonWidget.button)
        stackView.addArrangedSubview(remainingTimeWidget.label)
        playButtonWidget.delegate = self
    }

    func playButtonDidReceiveTap(_ playButtonWidget: PlayButtonWidget) {
        delegate?.audioBarWidget(audioBarWidget: self, didSelectAction: .playPause)
    }

    func configure(with presentable: AudioBarWidgetPresentable) {
        remainingTimeWidget.showRemainingTime(presentable.remainingTime)        
        playButtonWidget.setPlaying(presentable.isPlaying)
    }

    var view: UIView {
        return stackView
    }
    
}
