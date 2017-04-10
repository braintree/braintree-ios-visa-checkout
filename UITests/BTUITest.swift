import XCTest

extension XCTestCase {

//#if swift(>=3.1)
    func waitForElementToAppear(_ element: XCUIElement, timeout: TimeInterval = 10,  file: String = #file, line: UInt = #line) {
        let existsPredicate = NSPredicate(format: "exists == true")
        
        expectation(for: existsPredicate,
                                evaluatedWith: element, handler: nil)
        
        waitForExpectations(timeout: timeout) { (error) -> Void in
            if (error != nil) {
                let message = "Failed to find \(element) after \(timeout) seconds."
                self.recordFailure(withDescription: message, inFile: file, atLine: line, expected: true)
            }
        }
    }
    
    func waitForElementToBeHittable(_ element: XCUIElement, timeout: TimeInterval = 10,  file: String = #file, line: UInt = #line) {
        let existsPredicate = NSPredicate(format: "exists == true && hittable == true")
        
        expectation(for: existsPredicate,
                                evaluatedWith: element, handler: nil)
        
        waitForExpectations(timeout: timeout) { (error) -> Void in
            if (error != nil) {
                let message = "Failed to find \(element) after \(timeout) seconds."
                self.recordFailure(withDescription: message, inFile: file, atLine: line, expected: true)
            }
        }
    }
//#else
//    func waitForElementToAppear(element: XCUIElement, timeout: NSTimeInterval = 10,  file: String = #file, line: UInt = #line) {
//        let existsPredicate = NSPredicate(format: "exists == true")
//
//        expectationForPredicate(existsPredicate, evaluatedWithObject: element, handler: nil)
//
//        waitForExpectationsWithTimeout(timeout) { (error) -> Void in
//            if (error != nil) {
//                let message = "Failed to find \(element) after \(timeout) seconds."
//                self.recordFailureWithDescription(message, inFile: file, atLine: line, expected: true)
//            }
//        }
//    }
//
//    func waitForElementToBeHittable(element: XCUIElement, timeout: NSTimeInterval = 10,  file: String = #file, line: UInt = #line) {
//        let existsPredicate = NSPredicate(format: "exists == true && hittable == true")
//
//        expectationForPredicate(existsPredicate, evaluatedWithObject: element, handler: nil)
//
//        waitForExpectationsWithTimeout(timeout) { (error) -> Void in
//            if (error != nil) {
//                let message = "Failed to find \(element) after \(timeout) seconds."
//                self.recordFailureWithDescription(message, inFile: file, atLine: line, expected: true)
//            }
//        }
//    }
//#endif
}

extension XCUIElement {
//#if swift(>=3.1)
    func forceTapElement() {
        if self.isHittable {
            self.tap()
        } else {
            let coordinate: XCUICoordinate = self.coordinate(withNormalizedOffset: CGVector(dx: 0.0, dy: 0.0))
            coordinate.tap()
        }
    }
//#else
//    func forceTapElement() {
//        if self.hittable {
//            self.tap()
//        } else {
//            let coordinate: XCUICoordinate = self.coordinateWithNormalizedOffset(CGVectorMake(0.0, 0.0))
//            coordinate.tap()
//        }
//    }
//#endif
}
