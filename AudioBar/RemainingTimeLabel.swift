import UIKit

protocol RemainingTimeFormatting: class {

    func string(from timeInterval: TimeInterval) -> String?

}

extension DateComponentsFormatter: RemainingTimeFormatting {}

class RemainingTimeLabel: UILabel {

    var remainingTime: TimeInterval? {
        didSet {
            guard let remainingTime = remainingTime else {
                text = nil
                return
            }
            text = remainingTimeFormatter.string(from: remainingTime)
        }
    }

    var remainingTimeFormatter: RemainingTimeFormatting = DateComponentsFormatter(allowedUnits: [.minute, .second])

}

private extension DateComponentsFormatter {

    convenience init(allowedUnits: NSCalendar.Unit) {
        self.init()
        self.allowedUnits = allowedUnits
    }
    
}
