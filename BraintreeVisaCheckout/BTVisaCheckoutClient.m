#import "BTConfiguration+VisaCheckout.h"
#import "BTVisaCheckoutClient_Internal.h"
#import "BTVisaCheckoutCardNonce.h"
#import "BTAPIClient_Internal_Category.h"

NSString *const BTVisaCheckoutErrorDomain = @"com.braintreepayments.BTVisaCheckoutErrorDomain";

@interface BTVisaCheckoutClient ()
@end

@implementation BTVisaCheckoutClient

+ (void)load {
    if (self == [BTVisaCheckoutClient class]) {
        [[BTPaymentMethodNonceParser sharedParser] registerType:@"VisaCheckoutCard" withParsingBlock:^BTPaymentMethodNonce * _Nullable(BTJSON * _Nonnull visaCheckoutCard) {
            return [BTVisaCheckoutCardNonce visaCheckoutCardNonceWithJSON:visaCheckoutCard];
        }];
    }
}

- (instancetype)initWithAPIClient:(BTAPIClient *)apiClient {
    if (self = [super init]) {
        _apiClient = apiClient;
    }
    return self;
}

- (instancetype)init {
    return nil;
}

- (void)createProfile:(void (^)(id _Nullable, NSError * _Nullable))completion {
    [self.apiClient fetchOrReturnRemoteConfiguration:^(BTConfiguration * _Nullable configuration, NSError * _Nullable error) {
        if (error) {
            completion(nil, error);
            return;
        }

        if (![configuration isVisaCheckoutEnabled]) {
            NSError *error = [NSError errorWithDomain:BTVisaCheckoutErrorDomain
                                                 code:BTVisaCheckoutErrorTypeUnsupported
                                             userInfo:@{ NSLocalizedDescriptionKey: @"Visa Checkout is not enabled for this merchant. Please ensure that Visa Checkout is enabled in the Braintree Control Panel and try again." }];
            completion(nil, error);
            return;
        }

        id profile = [NSClassFromString(@"VisaProfile") alloc];
        SEL initSelector = NSSelectorFromString(@"initWithEnvironment:apiKey:profileName:");
        if (![profile respondsToSelector:initSelector]) {
            completion(nil, [NSError errorWithDomain:@"BTVisaCheckoutClient" code:BTVisaCheckoutErrorTypeIntegration userInfo:@{NSLocalizedDescriptionKey: @"VisaProfile initializer unavailable"}]);
            return;
        }

        NSInvocation *inv = [NSInvocation invocationWithMethodSignature:[profile methodSignatureForSelector:initSelector]];
        [inv setSelector:initSelector];
        [inv setTarget:profile];

        id environment = [[configuration.json[@"environment"] asString] isEqualToString:@"sandbox"] ? @(0) : @(1); // VisaEnvironmentSandbox = 0, VisaEnvironmentProduction = 1
        id apiKey = configuration.visaCheckoutAPIKey;
        id profileName = nil;
        // Arguments 0 and 1 are `self` and `_cmd` respectively, automatically set by NSInvocation
        [inv setArgument:&(environment) atIndex:2];
        [inv setArgument:&(apiKey) atIndex:3];
        [inv setArgument:&(profileName) atIndex:4];

        void *returnValue = NULL;
        [inv invoke];
        [inv getReturnValue:&returnValue];
        profile = (__bridge id)returnValue;

        [profile setValue:@(2) forKey:@"datalevel"]; // VisaDataLevelFull
        [profile setValue:configuration.visaCheckoutExternalClientId forKey:@"clientId"];

#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wundeclared-selector"
        [profile performSelector:@selector(acceptedCardBrands:) withObject:[configuration visaCheckoutSupportedNetworks]];
#pragma clang diagnostic pop

        completion(profile, nil);
    }];
}

- (void)tokenizeVisaCheckoutResult:(id)checkoutResult completion:(void (^)(BTVisaCheckoutCardNonce * _Nullable, NSError * _Nullable))completion {
    NSInteger statusCode;
    NSString *callId, *encryptedKey, *encryptedPaymentData;
    [self checkoutResult:checkoutResult statusCode:&statusCode callId:&callId encryptedKey:&encryptedKey encryptedPaymentData:&encryptedPaymentData];

    if (statusCode == 1) {
        [self.apiClient sendAnalyticsEvent:@"ios.visacheckout.result.cancelled"];
        completion(nil, nil);
        return;
    }

    if (statusCode != 0) {
        NSString *analyticEvent;
        switch(statusCode) {
            case 2:
                analyticEvent = @"duplicate-checkouts-open";
                break;
            case 3:
                analyticEvent = @"not-configured";
                break;
            case 4:
                analyticEvent = @"internal-error";
                break;
            default:
                analyticEvent = @"unknown";
        }

        NSError *error = [NSError errorWithDomain:BTVisaCheckoutErrorDomain
                                             code:BTVisaCheckoutErrorTypeCheckoutUnsuccessful
                                         userInfo:@{NSLocalizedDescriptionKey: [NSString stringWithFormat:@"Visa Checkout failed with status code %zd", statusCode]}];
        [self.apiClient sendAnalyticsEvent:[NSString stringWithFormat:@"ios.visacheckout.result.failed.%@", analyticEvent] ];
        completion(nil, error);
        return;
    }

    if (!callId || !encryptedKey || !encryptedPaymentData) {
        NSError *error = [NSError errorWithDomain:BTVisaCheckoutErrorDomain
                                             code:BTVisaCheckoutErrorTypeIntegration
                                         userInfo:@{NSLocalizedDescriptionKey: @"A valid VisaCheckoutResult is required."}];
        [self.apiClient sendAnalyticsEvent:@"ios.visacheckout.result.failed.invalid-payment"];
        completion(nil, error);
        return;
    }

    NSMutableDictionary *parameters = [NSMutableDictionary new];
    parameters[@"visaCheckoutCard"] = @{
                                        @"callId" : callId,
                                        @"encryptedKey" : encryptedKey,
                                        @"encryptedPaymentData" : encryptedPaymentData
                                        };

    [self.apiClient POST:@"v1/payment_methods/visa_checkout_cards"
              parameters:parameters
              completion:^(BTJSON *body, __unused NSHTTPURLResponse *response, NSError *error) {
                  if (error) {
                      completion(nil, error);
                      [self.apiClient sendAnalyticsEvent:@"ios.visacheckout.tokenize.failed"];
                      return;
                  }

                  BTJSON *visaCheckoutCard = body[@"visaCheckoutCards"][0];
                  BTVisaCheckoutCardNonce *tokenizedVisaCheckoutCard = [BTVisaCheckoutCardNonce visaCheckoutCardNonceWithJSON:visaCheckoutCard];
                  completion(tokenizedVisaCheckoutCard, nil);
                  [self.apiClient sendAnalyticsEvent:@"ios.visacheckout.tokenize.succeeded"];
              }];
}

#pragma mark - Helpers

- (void)checkoutResult:(id)checkoutResult
            statusCode:(NSInteger *)statusCode
                callId:(NSString **)callId
          encryptedKey:(NSString **)encryptedKey
  encryptedPaymentData:(NSString **)encryptedPaymentData {
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wundeclared-selector"
    NSInvocation *invocation = [NSInvocation invocationWithMethodSignature:[[checkoutResult class] instanceMethodSignatureForSelector:@selector(statusCode)]];
    [invocation setSelector:@selector(statusCode)];
    [invocation setTarget:checkoutResult];
    [invocation invoke];
    [invocation getReturnValue:statusCode];

    *callId = [checkoutResult respondsToSelector:@selector(callId)] ? [checkoutResult performSelector:@selector(callId)] : nil;
    *encryptedKey = [checkoutResult respondsToSelector:@selector(encryptedKey)] ? [checkoutResult performSelector:@selector(encryptedKey)] : nil;
    *encryptedPaymentData = [checkoutResult respondsToSelector:@selector(encryptedPaymentData)] ? [checkoutResult performSelector:@selector(encryptedPaymentData)] : nil;
#pragma clang diagnostic pop
}


@end
