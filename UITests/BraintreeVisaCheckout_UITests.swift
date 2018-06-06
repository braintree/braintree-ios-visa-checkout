import XCTest

class BraintreeVisaCheckout_UITests: XCTestCase {
        
    var app: XCUIApplication!
    
    override func setUp() {
        super.setUp()
        continueAfterFailure = false
        app = XCUIApplication()
        app.launchArguments.append("-EnvironmentSandbox")
        app.launchArguments.append("-TokenizationKey")
        app.launchArguments.append("-Integration:BraintreeDemoVisaCheckoutViewController")
        app.launch()
        sleep(2)
    }
    func testVisaCheckout_withSuccess_recievesNonceNew() {
        let visaButton = app.buttons["Visa Checkout Button"]
        self.waitForElementToAppear(visaButton)
        self.waitForElementToBeHittable(visaButton)
        sleep(2)
        visaButton.doubleTap()
        
        // Long delay to ensure animation completes to check signed in status
        sleep(3)

        // Go back to email login screen if previously signed in
        let continueAsNewCustomerButton = app.buttons.element(matching: NSPredicate(format: "label CONTAINS[c] %@", "Continue as new customer"))

        if (continueAsNewCustomerButton.exists) {
            self.waitForElementToBeHittable(continueAsNewCustomerButton)
            continueAsNewCustomerButton.forceTapElement()
            sleep(2)
        }

        app.staticTexts["Enter Your Email Address"].forceTapElement()
        sleep(2)

        app.webViews.otherElements["main"].textFields.element(boundBy: 0).typeText("no-reply-visa-checkout@getbraintree.com")
        app.buttons["Done"].tap()
        sleep(2)

        app.buttons.element(matching: NSPredicate(format: "label CONTAINS[c] %@", "Continue")).forceTapElement()
        sleep(2)

        app.staticTexts["Password"].forceTapElement()
        sleep(2)

        app.webViews.otherElements["main"].secureTextFields.element(boundBy: 0).typeText("12345678")
        app.buttons["Done"].tap()
        sleep(2)

        app.buttons.element(matching: NSPredicate(format: "label CONTAINS[c] %@", "Sign in to visa checkout")).forceTapElement()
        sleep(2)

        app.buttons.element(matching: NSPredicate(format: "label CONTAINS[c] %@", "Continue")).forceTapElement()
        sleep(2)
        
        self.waitForElementToAppear(app.buttons["Got a nonce. Tap to make a transaction."])
        XCTAssertTrue(app.buttons["Got a nonce. Tap to make a transaction."].exists)
    }
        
    func testVisaCheckout_returnToApp_whenCanceled() {
        let visaButton = app.buttons["Visa Checkout Button"]
        self.waitForElementToAppear(visaButton)
        self.waitForElementToBeHittable(visaButton)
        sleep(2)
        visaButton.doubleTap()

        sleep(2)
        self.waitForElementToBeHittable(app.buttons["Cancel and return to My App"])
        app.buttons["Cancel and return to My App"].tap()

        self.waitForElementToAppear(app.buttons["User canceled."])
        XCTAssertTrue(app.buttons["User canceled."].exists)
    }
}
