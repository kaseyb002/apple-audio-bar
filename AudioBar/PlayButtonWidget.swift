import UIKit

protocol PlayButtonWidgetDelegate: class {

    func playButtonDidReceiveTap(_ playButtonWidget: PlayButtonWidget)
    
}

protocol PlayButtonWidget: class {

    weak var delegate: PlayButtonWidgetDelegate? { get set }

    func setPlaying(_ playing: Bool)

    var button: UIButton { get }

}

class DefaultPlayButtonWidget: PlayButtonWidget {

    let button = UIButton(type: .system)

    var delegate: PlayButtonWidgetDelegate?

    init() {
        button.setTitle("play", for: .normal)
        button.addTarget(self, action: #selector(buttonDidReceiveTouchUpInside), for: .touchUpInside)
    }

    func setPlaying(_ playing: Bool) {
        let title = playing ? "pause" : "play"
        button.setTitle(title, for: .normal)
    }

    dynamic func buttonDidReceiveTouchUpInside() {
        delegate?.playButtonDidReceiveTap(self)
    }

}
