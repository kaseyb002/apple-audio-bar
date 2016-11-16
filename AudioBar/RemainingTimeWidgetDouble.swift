import UIKit

@testable import AudioBar

protocol RemainingTimeWidgetDouble: RemainingTimeWidget {}

extension RemainingTimeWidgetDouble {

    func showRemainingTime(_ remainingTime: TimeInterval?) {}

    var label: UILabel {
        return UILabel()
    }
    
}
