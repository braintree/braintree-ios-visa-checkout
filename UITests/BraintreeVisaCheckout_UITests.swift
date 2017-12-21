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
    func testVisaCheckout_withSuccess_recievesNonceNew() {
        let visaButton = app/*@START_MENU_TOKEN@*/.buttons["com_visa_checkout_bt_visaEXOButton"]/*[[".buttons[\"Visa Checkout\"]",".buttons[\"com_visa_checkout_bt_visaEXOButton\"]"],[[[-1,1],[-1,0]]],[0]]@END_MENU_TOKEN@*/
        visaButton.tap()
        
        // Long delay to ensure animation completes to check signed in status
        sleep(5)
        
        // Got back to email login screen if previously signed in
        if (XCUIApplication()/*@START_MENU_TOKEN@*/.buttons["com_visa_checkout_signIn_btn_notyou"]/*[[".buttons[\"Not no-reply-visa-checkout@getbraintree.com? Sign out of Visa Checkout or switch to another Visa Checkout account\"]",".buttons[\"com_visa_checkout_signIn_btn_notyou\"]"],[[[-1,1],[-1,0]]],[0]]@END_MENU_TOKEN@*/.exists) {
            XCUIApplication()/*@START_MENU_TOKEN@*/.buttons["com_visa_checkout_signIn_btn_notyou"]/*[[".buttons[\"Not no-reply-visa-checkout@getbraintree.com? Sign out of Visa Checkout or switch to another Visa Checkout account\"]",".buttons[\"com_visa_checkout_signIn_btn_notyou\"]"],[[[-1,1],[-1,0]]],[0]]@END_MENU_TOKEN@*/.tap()
        }
        
        self.waitForElementToBeHittable(app.textFields["com_visa_checkout_welcome_textfield_username"])
        app.textFields["com_visa_checkout_welcome_textfield_username"].typeText("no-reply-visa-checkout@getbraintree.com")

        let comVisaCheckoutWelcomeButtonContinueButton = XCUIApplication().buttons["com_visa_checkout_welcome_button_continue"]
        comVisaCheckoutWelcomeButtonContinueButton.tap()
    
        self.waitForElementToBeHittable(app.secureTextFields["com_visa_checkout_exo_textfield_password"])
        app.secureTextFields["com_visa_checkout_exo_textfield_password"].typeText("12345678")
        
        let comVisaCheckoutSigninBtnContinueButton = app/*@START_MENU_TOKEN@*/.buttons["com_visa_checkout_signIn_btn_continue"]/*[[".buttons[\"Sign in to Visa Checkout\"]",".buttons[\"com_visa_checkout_signIn_btn_continue\"]"],[[[-1,1],[-1,0]]],[0]]@END_MENU_TOKEN@*/
        comVisaCheckoutSigninBtnContinueButton.tap()
        
        let comVisaCheckoutRcBtnContinueButton = app/*@START_MENU_TOKEN@*/.buttons["com_visa_checkout_rc_btn_continue"]/*[[".buttons[\"Continue with this purchase\"]",".buttons[\"com_visa_checkout_rc_btn_continue\"]"],[[[-1,1],[-1,0]]],[0]]@END_MENU_TOKEN@*/
        self.waitForElementToBeHittable(comVisaCheckoutRcBtnContinueButton)
        comVisaCheckoutRcBtnContinueButton.tap()
        
        self.waitForElementToAppear(app.buttons["Got a nonce. Tap to make a transaction."])
        XCTAssertTrue(app.buttons["Got a nonce. Tap to make a transaction."].exists)
    }
        
    func testVisaCheckout_returnToApp_whenCanceled() {
        let visaButton = app/*@START_MENU_TOKEN@*/.buttons["com_visa_checkout_bt_visaEXOButton"]/*[[".buttons[\"Visa Checkout\"]",".buttons[\"com_visa_checkout_bt_visaEXOButton\"]"],[[[-1,1],[-1,0]]],[0]]@END_MENU_TOKEN@*/
        visaButton.tap()
        
        sleep(2)
        self.waitForElementToBeHittable(app.buttons["Close Visa Checkout"])
        app.buttons["Close Visa Checkout"].tap()

        self.waitForElementToBeHittable(app.buttons["Yes, close and cancel my purchase using Visa Checkout"])
        app.buttons["Yes, close and cancel my purchase using Visa Checkout"].tap()

        self.waitForElementToAppear(app.buttons["User canceled."])
        XCTAssertTrue(app.buttons["User canceled."].exists)
    }
}
