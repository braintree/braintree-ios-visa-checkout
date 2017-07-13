#import <XCTest/XCTest.h>
#import <UIKit/UIKit.h>

#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wdocumentation"

#import <VisaCheckoutSDK/VisaCheckout.h>

#pragma clang diagnostic pop

#import "BraintreeVisaCheckout.h"
#import "BTVisaCheckoutClient_Internal.h"

#define kTokenizationKeyWithVisaCheckout SANDBOX_TOKENIZATION_KEY
#define kTokenizationKeyWithoutVisaCheckout @"development_testing_altpay_sandbox_merchant"

@interface BraintreeVisaCheckout_IntegrationTests : XCTestCase
@property (nonatomic, strong) BTVisaCheckoutClient* visaCheckoutClient;
@property (nonatomic) VisaCheckoutResultStatus sampleCheckoutResultStatus;
@property (nonatomic, readwrite, copy) NSString * sampleCallId;
@property (nonatomic, readwrite, copy) NSString * sampleEncryptedKey;
@property (nonatomic, readwrite, copy) NSString * sampleEncryptedPaymentData;
@end

@implementation BraintreeVisaCheckout_IntegrationTests

- (void)setUp {
    [super setUp];

    BTAPIClient *apiClient = [[BTAPIClient alloc] initWithAuthorization:kTokenizationKeyWithVisaCheckout];
    self.visaCheckoutClient = [[BTVisaCheckoutClient alloc] initWithAPIClient:apiClient];
    self.sampleCheckoutResultStatus = VisaCheckoutResultStatusSuccess;
    self.sampleCallId = @"5318456373519624201";
    self.sampleEncryptedKey = @"FXVZWGhvZed5jAUCXuoiCVcsD0Eb6lvlwjAIE7Bxf/uMpQLT5g/Tcwhk3ujfl1zdQeUvJzdy+MMk+k7tjUZ9wtx+cknhHVni10yfFmkPgIblceq/YiQ0Kdea14fZxa1+";
    self.sampleEncryptedPaymentData = @"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";
}

- (void)testTokenizeVisaCheckoutResult_withValidVisaCheckoutResult_isSuccessful {
    XCTestExpectation *expectation = [self expectationWithDescription:@"Callback invoked"];
    [self.visaCheckoutClient tokenizeVisaCheckoutResult:self.sampleCheckoutResultStatus
                                                 callId:self.sampleCallId
                                           encryptedKey:self.sampleEncryptedKey
                                   encryptedPaymentData:self.sampleEncryptedPaymentData
                                             completion:^(BTVisaCheckoutCardNonce * _Nullable tokenizedVisaCheckoutCard, NSError * _Nullable error) {
        XCTAssertNotNil(tokenizedVisaCheckoutCard);
        XCTAssertNil(error);
        [expectation fulfill];

    }];

    [self waitForExpectationsWithTimeout:5 handler:nil];
}

- (void)testTokenizeVisaCheckoutResult_whenDecryptionFails_isNotSuccessful {
    XCTestExpectation *expectation = [self expectationWithDescription:@"Callback invoked"];
    [self.visaCheckoutClient tokenizeVisaCheckoutResult:self.sampleCheckoutResultStatus
                                                 callId:@"callId"
                                           encryptedKey:@"encKey"
                                   encryptedPaymentData:@"encryptedPayload"
                                             completion:^(BTVisaCheckoutCardNonce * _Nullable tokenizedVisaCheckoutCard, NSError * _Nullable error) {
        XCTAssertNotNil(error);
        XCTAssertNil(tokenizedVisaCheckoutCard);
        XCTAssertEqualObjects(error.localizedDescription, @"Visa Checkout payment data decryption failed");
        [expectation fulfill];

    }];

    [self waitForExpectationsWithTimeout:5 handler:nil];
}

- (void)testTokenizeVisaCheckoutResult_withInvalidVisaCheckoutResult_isNotSuccessful {
    XCTestExpectation *expectation = [self expectationWithDescription:@"Callback invoked"];
    [self.visaCheckoutClient tokenizeVisaCheckoutResult:self.sampleCheckoutResultStatus
                                                 callId:nil
                                           encryptedKey:nil
                                   encryptedPaymentData:nil
                                             completion:^(BTVisaCheckoutCardNonce * _Nullable tokenizedVisaCheckoutCard, NSError * _Nullable error) {
        XCTAssertNotNil(error);
        XCTAssertNil(tokenizedVisaCheckoutCard);
        XCTAssertEqualObjects(error.localizedDescription, @"A valid VisaCheckoutResult is required.");
        [expectation fulfill];
    }];

    [self waitForExpectationsWithTimeout:5 handler:nil];
}

@end
