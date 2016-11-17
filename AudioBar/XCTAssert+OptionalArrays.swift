import XCTest

func XCTAssertEqual<T: Equatable>(_ array1: [T?], _ array2: [T?], file: StaticString = #file, line: UInt = #line) {
    let hasDifferentCount = array1.count != array2.count
    let hasDifferentElements = zip(array1, array2).contains { $0 != $1 }
    if hasDifferentCount || hasDifferentElements {
        let arrayDescription1 = String(describing: array1)
        let arrayDescription2 = String(describing: array2)
        XCTFail(arrayDescription1 + " is not equal to " + arrayDescription2, file: file, line: line)
    }
}
