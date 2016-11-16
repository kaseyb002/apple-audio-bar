import XCTest

func XCTAssertEqual(_ array1: [AnyObject], _ array2: [AnyObject], file: StaticString = #file, line: UInt = #line) {
    let hasDifferentCount = array1.count != array2.count
    let hasDifferentElements = zip(array1, array2).contains { $0 !== $1 }
    if hasDifferentCount || hasDifferentElements {
        let arrayDescription1 = String(describing: array1.map(describeObject))
        let arrayDescription2 = String(describing: array2.map(describeObject))
        XCTFail(arrayDescription1 + " is not equal to " + arrayDescription2, file: file, line: line)
    }
}

func XCTAssertConstant(_ object: @autoclosure () -> AnyObject, file: StaticString = #file, line: UInt = #line) {
    XCTAssertEqual(object(), object(), file: file, line: line)
}

func XCTAssertEqual(_ object1: AnyObject?, _ object2: AnyObject?, file: StaticString = #file, line: UInt = #line) {
    if object1 !== object2 {
        let failureDescription = describeObject(object1) + " is not equal to " + describeObject(object2)
        XCTFail(failureDescription, file: file, line: line)
    }
}

private func describeObject(_ object: AnyObject?) -> String {
    guard let object = object else { return "nil" }
    let pointer = Int(bitPattern: ObjectIdentifier(object))
    let pointerDescription = "0x" + String(pointer, radix: 16)
    return String(describing: object) + "(" + pointerDescription + ")"
}
