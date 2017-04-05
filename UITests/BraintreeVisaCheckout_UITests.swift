#if swift(>=3.1)
#else
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

        if (elementsQuery.otherElements["com_visa_checkout_tvSignUpGoToSignIn"].exists) {
            elementsQuery.otherElements["com_visa_checkout_btSignUpContinue"].swipeUp()
        
            let loginButton = elementsQuery.staticTexts["com_visa_checkout_tvSignUpGoToSignIn"]
            loginButton.tap()
        }
        
        let signInElement = elementsQuery.otherElements["com.visa.android.integration.checkoutsampleapp.app:id/com_visa_checkout_etSignInUsername"]

        signInElement.pressForDuration(1.1)
        UIPasteboard.generalPasteboard().string = "no-reply-visa-checkout@getbraintree.com"
        app.menuItems["Paste"].tap()

        let passwordElement = elementsQuery.otherElements["com.visa.android.integration.checkoutsampleapp.app:id/com_visa_checkout_etSignInPassword"]

        passwordElement.pressForDuration(1.1)
        UIPasteboard.generalPasteboard().string = "12345678"
        app.menuItems["Paste"].tap()
        
        elementsQuery.otherElements["com_visa_checkout_btSignIn"].tap()
        elementsQuery.otherElements["com_visa_checkout_bt_rc_pay_continue"].tap()

        self.waitForElementToAppear(app.buttons["Got a nonce. Tap to make a transaction."])
        XCTAssertTrue(app.buttons["Got a nonce. Tap to make a transaction."].exists)
    }
}
#endif
