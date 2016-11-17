import UIKit

@testable import AudioBar

protocol SeekWidgetDouble: SeekWidget {}

extension SeekWidgetDouble {

    var delegate: PlayButtonWidgetDelegate? {
        get { return nil }
        set {}
    }

    func setEnabled(enabled: Bool, for action: SeekWidgetAction) {}

    func view(for action: SeekWidgetAction) -> UIView {
        return UIView()
    }

}

class DefaultSeekWidgetDouble: SeekWidgetDouble {}
