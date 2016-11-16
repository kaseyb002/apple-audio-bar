import UIKit

@testable import AudioBar

protocol PlayButtonWidgetDouble: PlayButtonWidget {}

extension PlayButtonWidgetDouble {

    var delegate: PlayButtonWidgetDelegate? {
        get { return nil }
        set {}
    }

    func setState(_ state: PlayButtonState) {}

    var button: UIButton {
        return UIButton()
    }

}
