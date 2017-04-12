import Foundation
#if swift(>=3.1)
// Warning
#else
import VisaCheckoutSDK
import XCTest
    
class BTVisaCheckout_Tests: XCTestCase {

    let mockAPIClient = MockAPIClient(authorization: "development_tokenization_key")!

    func testCreateProfile_whenConfigurationFetchErrorOccurs_callsCompletionWithError() {
        mockAPIClient.cannedConfigurationResponseError = NSError(domain: "MyError", code: 123, userInfo: nil)

        let client = BTVisaCheckoutClient(apiClient: mockAPIClient)
        let expecation = expectation(description: "profile error")

        client.createProfile { (profile, error) in
            let err = error! as NSError
            XCTAssertNil(profile)
            XCTAssertEqual(err.domain, "MyError")
            XCTAssertEqual(err.code, 123)

            expecation.fulfill()
        }

        waitForExpectations(timeout: 1, handler: nil)
    }

    func testCreateProfile_whenVisaCheckoutIsNotEnabled_callsBackWithError() {
        mockAPIClient.cannedConfigurationResponseBody = BTJSON(value: {})

        let client = BTVisaCheckoutClient(apiClient: mockAPIClient)
        let expecation = expectation(description: "profile error")

        client.createProfile { (profile, error) in
            let err = error! as NSError

            XCTAssertNil(profile)
            XCTAssertEqual(err.domain, BTVisaCheckoutErrorDomain)
            XCTAssertEqual(err.code, BTVisaCheckoutErrorType.unsupported.rawValue)

            expecation.fulfill()
        }

        waitForExpectations(timeout: 1, handler: nil)
    }

    func testCreateProfile_whenSuccessful_returnsProfileWithArgs() {
        mockAPIClient.cannedConfigurationResponseBody = BTJSON(value: [
            "environment": "sandbox",
            "visaCheckout": [
                "apikey": "API Key",
                "externalClientId": "clientExternalId",
                "supportedCardTypes": [
                    "Visa",
                    "MasterCard",
                    "American Express",
                    "Discover"
                ]
            ]
        ])

        let client = BTVisaCheckoutClient(apiClient: mockAPIClient)
        let expecation = expectation(description: "profile success")

        client.createProfile { (profile, error) in
            guard let visaProfile = profile as? Profile else {
                XCTFail()
                return
            }

            XCTAssertNil(error)
            XCTAssertEqual(visaProfile.apiKey, "API Key")
            XCTAssertEqual(visaProfile.environment, .sandbox)
            XCTAssertEqual(visaProfile.datalevel, DataLevel.full)
            XCTAssertEqual(visaProfile.clientId, "clientExternalId")
            if let acceptedCardBrands = visaProfile.acceptedCardBrands {
                XCTAssertEqual(acceptedCardBrands, [CardBrand.visa, CardBrand.mastercard, CardBrand.amex, CardBrand.discover])
            } else {
                XCTFail()
            }


            expecation.fulfill()
        }

        waitForExpectations(timeout: 1, handler: nil)
    }

    func testTokenize_whenMalformedCheckoutResult_callsCompletionWithError() {
        mockAPIClient.cannedConfigurationResponseBody = BTJSON(value: [
            "environment": "sandbox",
            "visaCheckout": [
                "apikey": "API Key",
                "externalClientId": "clientExternalId",
                "supportedCardTypes": [
                    "Visa",
                    "MasterCard",
                    "American Express",
                    "Discover"
                ]
            ]
            ])
        let client = BTVisaCheckoutClient(apiClient: mockAPIClient)
        let expectedErr = NSError(domain: BTVisaCheckoutErrorDomain, code: BTVisaCheckoutErrorType.integration.rawValue, userInfo: [NSLocalizedDescriptionKey: "A valid VisaCheckoutResult is required."])

        let malformedCheckoutResults = [
            VisaCheckoutResult(callId: nil, encryptedKey: "a", encryptedPaymentData: "b"),
            VisaCheckoutResult(callId: "a", encryptedKey: nil, encryptedPaymentData: "b"),
            VisaCheckoutResult(callId: "a", encryptedKey: "b", encryptedPaymentData: nil)
        ]
        malformedCheckoutResults.forEach { checkoutResult in
            let expecation = expectation(description: "tokenization error due to malformed CheckoutResult")

            client.tokenize(checkoutResult) { (nonce, err) in
                if nonce != nil {
                    XCTFail()
                    return
                }

                guard let err = err as? NSError else {
                    XCTFail()
                    return
                }

                XCTAssertEqual(err, expectedErr)
                expecation.fulfill()
            }
            
            waitForExpectations(timeout: 1, handler: nil)
        }
    }

    func testTokenize_whenStatusCodeIndicatesCancellation_callsCompletionWithNilNonceAndError() {
        let client = BTVisaCheckoutClient(apiClient: mockAPIClient)
        let result = VisaCheckoutResult()
        result.statusCode = 1

        let expectation = self.expectation(description: "Callback invoked")
        client.tokenize(result) { (tokenizedCheckoutResult, error) in
            XCTAssertNil(tokenizedCheckoutResult)
            XCTAssertNil(error)
            expectation.fulfill()
        }

        self.waitForExpectations(timeout: 1, handler: nil)
    }

    func testTokenize_whenStatusCodeIndicatesError_callsCompletionWitheError() {
        let client = BTVisaCheckoutClient(apiClient: mockAPIClient)
        let statusCodes = 2...4

        statusCodes.forEach { statusCode in
            let result = VisaCheckoutResult()
            result.statusCode = statusCode

            let expectation = self.expectation(description: "Callback invoked")
            client.tokenize(result) { (_, error) in
                guard let error = error as? NSError else {
                    XCTFail()
                    return
                }

                XCTAssertEqual(error.domain, BTVisaCheckoutErrorDomain)
                XCTAssertEqual(error.code, BTVisaCheckoutErrorType.checkoutUnsuccessful.rawValue)
                XCTAssertEqual(error.localizedDescription, "Visa Checkout failed with status code \(statusCode)")
                expectation.fulfill()
            }

            self.waitForExpectations(timeout: 1, handler: nil)
        }
    }

    func testTokenize_whenStatusCodeIndicatesCancellation_callsAnalyticsWithCancelled() {
        let client = BTVisaCheckoutClient(apiClient: mockAPIClient)
        let result = VisaCheckoutResult()
        result.statusCode = 1

        let expectation = self.expectation(description: "Analytic sent")
        client.tokenize(result) { _ in
            XCTAssertEqual(self.mockAPIClient.postedAnalyticsEvents.last!, "ios.visacheckout.result.cancelled")
            expectation.fulfill()
        }

        self.waitForExpectations(timeout: 1, handler: nil)
    }

    func testTokenize_whenStatusCodeIndicatesError_callsAnalyticsWitheError() {
        let client = BTVisaCheckoutClient(apiClient: mockAPIClient)
        let statusCodes = [
            (statusCode: 2, analyticEvent: "ios.visacheckout.result.failed.duplicate-checkouts-open"),
            (statusCode: 3, analyticEvent: "ios.visacheckout.result.failed.not-configured"),
            (statusCode: 4, analyticEvent: "ios.visacheckout.result.failed.internal-error"),
            (statusCode: 999, analyticEvent: "ios.visacheckout.result.failed.unknown")
        ]

        statusCodes.forEach { (statusCode, analyticEvent) in
            let result = VisaCheckoutResult()
            result.statusCode = statusCode

            let expectation = self.expectation(description: "Analytic sent")
            client.tokenize(result) { _ in
                XCTAssertEqual(self.mockAPIClient.postedAnalyticsEvents.last!, analyticEvent)
                expectation.fulfill()
            }

            self.waitForExpectations(timeout: 1, handler: nil)
        }
    }

    func testTokenize_whenTokenizationErrorOccurs_callsCompletionWithError() {
        mockAPIClient.cannedConfigurationResponseBody = BTJSON(value: [
            "environment": "sandbox",
            "visaCheckout": [
                "apikey": "API Key",
                "externalClientId": "clientExternalId",
                "supportedCardTypes": [
                    "Visa",
                    "MasterCard",
                    "American Express",
                    "Discover"
                ]
            ]
            ])
        mockAPIClient.cannedHTTPURLResponse = HTTPURLResponse(url: URL(string: "any")!, statusCode: 503, httpVersion: nil, headerFields: nil)
        mockAPIClient.cannedResponseError = NSError(domain: "foo", code: 123, userInfo: nil)

        let client = BTVisaCheckoutClient(apiClient: mockAPIClient)
        let expecation = expectation(description: "tokenization error")

        client.tokenize(VisaCheckoutResult()) { (nonce, err) in
            if nonce != nil {
                XCTFail()
                return
            }

            guard let err = err as? NSError else {
                XCTFail()
                return
            }

            XCTAssertEqual(err, self.mockAPIClient.cannedResponseError)
            expecation.fulfill()
        }

        waitForExpectations(timeout: 1, handler: nil)
    }

    func testTokenize_whenTokenizationErrorOccurs_sendsAnalyticsEvent() {
        mockAPIClient.cannedConfigurationResponseBody = BTJSON(value: [
            "environment": "sandbox",
            "visaCheckout": [
                "apikey": "API Key",
                "externalClientId": "clientExternalId",
                "supportedCardTypes": [
                    "Visa",
                    "MasterCard",
                    "American Express",
                    "Discover"
                ]
            ]
            ])
        mockAPIClient.cannedHTTPURLResponse = HTTPURLResponse(url: URL(string: "any")!, statusCode: 503, httpVersion: nil, headerFields: nil)
        mockAPIClient.cannedResponseError = NSError(domain: "foo", code: 123, userInfo: nil)

        let client = BTVisaCheckoutClient(apiClient: mockAPIClient)
        let expecation = expectation(description: "tokenization error")

        client.tokenize(VisaCheckoutResult()) { _ in
            expecation.fulfill()
        }

        waitForExpectations(timeout: 1, handler: nil)
        XCTAssertEqual(self.mockAPIClient.postedAnalyticsEvents.last, "ios.visacheckout.tokenize.failed")
    }

    func testTokenize_whenCalled_makesPOSTRequestToTokenizationEndpoint() {
        let client = BTVisaCheckoutClient(apiClient: mockAPIClient)
        let expecation = expectation(description: "tokenization success")

        client.tokenize(VisaCheckoutResult()) { _ in
            expecation.fulfill()
        }

        waitForExpectations(timeout: 1, handler: nil)

        XCTAssertEqual(self.mockAPIClient.lastPOSTPath, "v1/payment_methods/visa_checkout_cards")
        if let visaCheckoutCard = self.mockAPIClient.lastPOSTParameters?["visaCheckoutCard"] as? [String: String] {
            XCTAssertEqual(visaCheckoutCard, [
                "callId": "callId",
                "encryptedKey": "encryptedKey",
                "encryptedPaymentData": "encryptedPaymentData"
                ])
        } else {
            XCTFail()
            return
        }
    }

    func testTokenize_whenMissingPhoneNumber_returnsNilForBothAddresses() {
        mockAPIClient.cannedResponseBody = BTJSON(value: [
            "visaCheckoutCards":[[
                "type": "VisaCheckoutCard",
                "nonce": "123456-12345-12345-a-adfa",
                "description": "ending in ••11",
                "default": false,
                "details": [
                    "cardType": "Visa",
                    "lastTwo": "11"
                ],
                "shippingAddress": [
                    "firstName": "BT - shipping",
                    "lastName": "Test - shipping",
                    "streetAddress": "123 Townsend St Fl 6 - shipping",
                    "locality": "San Francisco - shipping",
                    "region": "CA - shipping",
                    "postalCode": "94107 - shipping",
                    "countryCode": "US - shipping"
                ],
                "billingAddress": [
                    "firstName": "BT - billing",
                    "lastName": "Test - billing",
                    "streetAddress": "123 Townsend St Fl 6 - billing",
                    "locality": "San Francisco - billing",
                    "region": "CA - billing",
                    "postalCode": "94107 - billing",
                    "countryCode": "US - billing"
                ]
                ]]
            ])

        let client = BTVisaCheckoutClient(apiClient: mockAPIClient)
        let expecation = expectation(description: "tokenization success")

        client.tokenize(VisaCheckoutResult()) { (nonce, error) in
            if (error != nil) {
                XCTFail()
                return
            }

            guard let nonce = nonce else {
                XCTFail()
                return
            }
            
            XCTAssertNil(nonce.shippingAddress!.phoneNumber)
            XCTAssertNil(nonce.billingAddress!.phoneNumber)

            expecation.fulfill()
        }

        waitForExpectations(timeout: 1, handler: nil)
    }

    func testTokenize_whenTokenizationSuccess_callsAPIClientWithVisaCheckoutCard() {
        mockAPIClient.cannedResponseBody = BTJSON(value: [
            "visaCheckoutCards":[[
                "type": "VisaCheckoutCard",
                "nonce": "123456-12345-12345-a-adfa",
                "description": "ending in ••11",
                "default": false,
                "details": [
                    "cardType": "Visa",
                    "lastTwo": "11"
                ],
                "shippingAddress": [
                    "firstName": "BT - shipping",
                    "lastName": "Test - shipping",
                    "streetAddress": "123 Townsend St Fl 6 - shipping",
                    "extendedAddress": "Unit 123 - shipping",
                    "locality": "San Francisco - shipping",
                    "region": "CA - shipping",
                    "postalCode": "94107 - shipping",
                    "countryCode": "US - shipping",
                    "phoneNumber": "1234567890 - shipping"
                ],
                "billingAddress": [
                    "firstName": "BT - billing",
                    "lastName": "Test - billing",
                    "streetAddress": "123 Townsend St Fl 6 - billing",
                    "extendedAddress": "Unit 123 - billing",
                    "locality": "San Francisco - billing",
                    "region": "CA - billing",
                    "postalCode": "94107 - billing",
                    "countryCode": "US - billing",
                    "phoneNumber": "1234567890 - billing"
                ],
                "userData": [
                    "userFirstName": "userFirstName",
                    "userLastName": "userLastName",
                    "userFullName": "userFullName",
                    "userName": "userUserName",
                    "userEmail": "userEmail"
                ]
                ]]
            ])

        let client = BTVisaCheckoutClient(apiClient: mockAPIClient)
        let expecation = expectation(description: "tokenization success")

        client.tokenize(VisaCheckoutResult()) { (nonce, error) in
            if (error != nil) {
                XCTFail()
                return
            }

            guard let nonce = nonce else {
                XCTFail()
                return
            }

            XCTAssertEqual(nonce.type, "VisaCheckoutCard")
            XCTAssertEqual(nonce.nonce, "123456-12345-12345-a-adfa")
            XCTAssertEqual(nonce.localizedDescription, "ending in ••11")
            XCTAssertTrue(nonce.cardNetwork == BTCardNetwork.visa)
            XCTAssertEqual(nonce.lastTwo, "11")

            [(nonce.shippingAddress!, "shipping"), (nonce.billingAddress!, "billing")].forEach { (address, type) in
                XCTAssertEqual(address.firstName, "BT - " + type)
                XCTAssertEqual(address.lastName, "Test - " + type)
                XCTAssertEqual(address.streetAddress, "123 Townsend St Fl 6 - " + type)
                XCTAssertEqual(address.extendedAddress, "Unit 123 - " + type)
                XCTAssertEqual(address.locality, "San Francisco - " + type)
                XCTAssertEqual(address.region, "CA - " + type)
                XCTAssertEqual(address.postalCode, "94107 - " + type)
                XCTAssertEqual(address.countryCode, "US - " + type)
                XCTAssertEqual(address.phoneNumber, "1234567890 - " + type)
            }

            XCTAssertEqual(nonce.userData!.firstName, "userFirstName")
            XCTAssertEqual(nonce.userData!.lastName, "userLastName")
            XCTAssertEqual(nonce.userData!.fullName, "userFullName")
            XCTAssertEqual(nonce.userData!.username, "userUserName")
            XCTAssertEqual(nonce.userData!.email, "userEmail")

            expecation.fulfill()
        }

        waitForExpectations(timeout: 1, handler: nil)
    }

    func testTokenize_whenTokenizationSuccess_sendsAnalyticEvent() {
        mockAPIClient.cannedResponseBody = BTJSON(value: [
            "visaCheckoutCards":[[:]]
            ])

        let client = BTVisaCheckoutClient(apiClient: mockAPIClient)
        let expecation = expectation(description: "tokenization success")

        client.tokenize(VisaCheckoutResult()) { _ in
            expecation.fulfill()
        }
        
        waitForExpectations(timeout: 1, handler: nil)
        XCTAssertEqual(self.mockAPIClient.postedAnalyticsEvents.last!, "ios.visacheckout.tokenize.succeeded")
    }
}


// MARK: - Test doubles

@objc class VisaCheckoutResult: NSObject {
    var callId: String? = "callId"
    var encryptedKey: String? = "encryptedKey"
    var encryptedPaymentData: String? = "encryptedPaymentData"
    var statusCode: Int = 0

    convenience init(callId: String?, encryptedKey: String?, encryptedPaymentData: String?) {
        self.init()
        self.callId = callId
        self.encryptedKey = encryptedKey
        self.encryptedPaymentData = encryptedPaymentData
    }
}
#endif
