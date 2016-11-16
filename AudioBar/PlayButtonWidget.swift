import UIKit

enum PlayButtonState { case playing, paused }

protocol PlayButtonWidgetDelegate: class {

    func playButtonDidReceiveTap(_ playButtonWidget: PlayButtonWidget)
    
}

protocol PlayButtonWidget: class {

    func setState(_ state: PlayButtonState)

    weak var delegate: PlayButtonWidgetDelegate? { get set }

    var button: UIButton { get }

}

class DefaultPlayButtonWidget: PlayButtonWidget {

    func setState(_ state: PlayButtonState) {
        switch state {
        case .playing:
            button.setTitle("pause", for: .normal)
        case .paused:
            button.setTitle("play", for: .normal)
        }
    }

    let button = UIButton(type: .system)

    var delegate: PlayButtonWidgetDelegate?

    init() {
        button.setTitle("play", for: .normal)
        button.addTarget(self, action: #selector(buttonDidReceiveTouchUpInside), for: .touchUpInside)
    }

    dynamic func buttonDidReceiveTouchUpInside() {
        delegate?.playButtonDidReceiveTap(self)
    }

}
