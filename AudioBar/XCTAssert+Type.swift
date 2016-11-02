import XCTest

func XCTAssert<Type>(_ subject: Type, is expectedType: Any.Type, file: StaticString = #file, line: UInt = #line) {
    if type(of: subject) != expectedType {
        let subjectDescription = String(describing: type(of: subject))
        let expectedTypeDescription = String(describing: expectedType)
        let failureDescription = subjectDescription + " is not equal to " + expectedTypeDescription
        XCTFail(failureDescription, file: file, line: line)
    }
}

func XCTAssert<Type: AnyObject>(_ subject: Type, directlyInheritsFrom superclass: Any.Type, file: StaticString = #file, line: UInt = #line) {
    guard let superclassMirror = Mirror(reflecting: subject).superclassMirror else {
        XCTFail()
        return
    }
    if superclassMirror.subjectType != superclass {
        let subjectDescription = String(describing: type(of: subject))
        let expectedSuperclassDescription = String(describing: superclass)
        let failureDescription = subjectDescription + " is not a direct subclass of " + expectedSuperclassDescription
        XCTFail(failureDescription, file: file, line: line)
    }
}
