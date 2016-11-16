import UIKit

protocol RemainingTimeWidget: class {

    func showRemainingTime(_ remainingTime: TimeInterval?)

    var label: UILabel { get }

}

class DefaultRemainingTimeWidget: RemainingTimeWidget {

    let label = UILabel()

    func showRemainingTime(_ remainingTime: TimeInterval?) {
        guard let remainingTime = remainingTime, let formattedTime = timeFormatting.string(from: remainingTime) else {
            label.text = nil
            return
        }
        label.text = "-" + formattedTime
    }

    var timeFormatting: TimeFormatting = DateComponentsFormatter(allowedUnits: [.minute, .second])

}

private extension DateComponentsFormatter {

    convenience init(allowedUnits: NSCalendar.Unit) {
        self.init()
        self.allowedUnits = allowedUnits
    }
    
}
