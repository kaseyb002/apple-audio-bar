import UIKit

@testable import AudioBar

protocol PlayButtonWidgetDouble: PlayButtonWidget {}

extension PlayButtonWidgetDouble {

    var delegate: PlayButtonWidgetDelegate? {
        get { return nil }
        set {}
    }

    func setPlaying(_ playing: Bool) {}

    var button: UIButton {
        return UIButton()
    }

}

class DefaultPlayButtonWidgetDouble: PlayButtonWidgetDouble {}



protocol ViewAnimating {

    static func animate(withDuration duration: TimeInterval, animations: @escaping () -> Void)

}

extension UIView: ViewAnimating {}

class Animator {

    let viewAnimating: ViewAnimating.Type

    init(viewAnimating: ViewAnimating.Type = UIView.self) {
        self.viewAnimating = viewAnimating
    }

    func animate(withDuration duration: TimeInterval, animations: @escaping () -> Void) {
        viewAnimating.animate(withDuration: duration, animations: animations)
    }

}


//class PlayButtonWidgetMock: PlayButtonWidget {
//
//    var delegate: PlayButtonWidgetDelegate?
//
//    var isPlaying = false
//
//    func setPlaying(_ playing: Bool) {
//        isPlaying = playing
//    }
//
//    let view = UIButton()
//
//}
