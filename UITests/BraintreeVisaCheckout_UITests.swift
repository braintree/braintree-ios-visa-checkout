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
        sleep(1)
    }

    func testVisaCheckout_withSuccess_recievesNonce() {
        let visaButton = app.otherElements["visaEXOButton"]
        visaButton.tap()
        
        let elementsQuery = app.scrollViews.otherElements
        let loginButton = elementsQuery.staticTexts["com_visa_checkout_tvSignUpGoToSignIn"]

        if (loginButton.exists) {
            elementsQuery.otherElements["com_visa_checkout_btSignUpContinue"].swipeUp()
            loginButton.tap()
        }

        let signInElement = elementsQuery.otherElements["com.visa.android.integration.checkoutsampleapp.app:id/com_visa_checkout_etSignInUsername"]

        signInElement.press(forDuration: 1.1)
        UIPasteboard.general.string = "no-reply-visa-checkout@getbraintree.com"
        app.menuItems["Paste"].tap()

        let passwordElement = elementsQuery.otherElements["com.visa.android.integration.checkoutsampleapp.app:id/com_visa_checkout_etSignInPassword"]

        passwordElement.press(forDuration: 1.1)
        UIPasteboard.general.string = "12345678"
        app.menuItems["Paste"].tap()
        
        elementsQuery.otherElements["com_visa_checkout_btSignIn"].tap()
        elementsQuery.otherElements["com_visa_checkout_bt_rc_pay_continue"].tap()

        self.waitForElementToAppear(app.buttons["Got a nonce. Tap to make a transaction."])
        XCTAssertTrue(app.buttons["Got a nonce. Tap to make a transaction."].exists)
    }
}
