import UIKit

enum SeekWidgetAction { case back, forward }

protocol SeekWidgetDelegate: class {

    func seekWidget(_ seekWidget: SeekWidget, didReceiveTapFor action: SeekWidgetAction)

}

protocol SeekWidget: class {

    weak var delegate: PlayButtonWidgetDelegate? { get set }

    func setEnabled(enabled: Bool, for action: SeekWidgetAction)
    func view(for action: SeekWidgetAction) -> UIView

}
