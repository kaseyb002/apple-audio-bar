import XCTest
import UIKit

func XCTAssertConstraint(_ constraint: NSLayoutConstraint, inView view: UIView, file: StaticString = #file, line: UInt = #line) {
    switch view.numberOfConstraintsMatching(constraint: constraint) {
    case 0:
        XCTFail("No matching constraints found", file: file, line: line)
    case let count where count > 1:
        XCTFail("Multiple matching constraints found", file: file, line: line)
    default:
        break
    }
}

private extension UIView {
    func numberOfConstraintsMatching(constraint: NSLayoutConstraint) -> Int {
        return constraints.filter(constraint.matchesConstraint).count
    }
}

private extension NSLayoutConstraint {
    func matchesConstraint(otherConstraint: NSLayoutConstraint) -> Bool {
        return true
            && priority == otherConstraint.priority
            && firstItem === otherConstraint.firstItem
            && firstAttribute == otherConstraint.firstAttribute
            && relation == otherConstraint.relation
            && secondItem === otherConstraint.secondItem
            && secondAttribute == otherConstraint.secondAttribute
            && multiplier == otherConstraint.multiplier
            && constant == otherConstraint.constant
    }
}
