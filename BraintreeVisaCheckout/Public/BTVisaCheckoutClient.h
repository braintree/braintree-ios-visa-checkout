#pragma message "⚠️ Braintree's Visa Checkout API for iOS is currently in beta and may change."

#if __has_include("BraintreeCore.h")
#import "BraintreeCore.h"
#endif

#if __has_include(<BraintreeCore/BraintreeCore.h>)
#import <BraintreeCore/BraintreeCore.h>
#endif

#if __has_include(<Braintree/BraintreeCore.h>)
#import <Braintree/BraintreeCore.h>
#endif

#import "BTVisaCheckoutCardNonce.h"
#import "BTConfiguration+VisaCheckout.h"
@import VisaCheckoutSDK;

@class BTAPIClient;

NS_ASSUME_NONNULL_BEGIN

extern NSString * const BTVisaCheckoutErrorDomain;
typedef NS_ENUM(NSInteger, BTVisaCheckoutErrorType) {
    BTVisaCheckoutErrorTypeUnknown = 0,
    
    /// Visa Checkout is disabled in the Braintree Control Panel.
    BTVisaCheckoutErrorTypeUnsupported,
    
    /// Braintree SDK is integrated incorrectly.
    BTVisaCheckoutErrorTypeIntegration,

    /// Visa Checkout SDK responded with an unsuccessful status code.
    BTVisaCheckoutErrorTypeCheckoutUnsuccessful,
};

@interface BTVisaCheckoutClient : NSObject

/*!
 @brief Creates a Visa Checkout client.

 @param apiClient An API client.
 @returns A Visa Checkout client.
 */
- (instancetype)initWithAPIClient:(BTAPIClient *)apiClient NS_DESIGNATED_INITIALIZER;


- (instancetype)init __attribute__((unavailable("Please use initWithAPIClient:")));

/*!
 @brief Creates a Visa Checkout profile.

 @param completion A completion block that is invoked when the profile is created.
        `profile` will be an instance of VisaProfile when successful, otherwise `nil`.
        `error` will be the related error if VisaProfile could not be created, otherwise `nil`.
 */

- (void)createProfile:(void (^)(VisaProfile * _Nullable profile, NSError * _Nullable error))completion;

/*!
 @brief Tokenizes a `VisaCheckoutResult`.

 @note The `checkoutResult` parameter is declared as `id` type, but you must pass a `VisaCheckoutResult` instance.

 @param checkoutResult A `VisaCheckoutResult` instance.
 @param completion A completion block that is invoked when tokenization has completed. If tokenization succeeds,
        `tokenizedVisaCheckoutCard` will contain a nonce and `error` will be `nil`; if it fails,
        `tokenizedVisaCheckoutCard` will be `nil` and `error` will describe the failure.
 */
- (void)tokenizeVisaCheckoutResult:(VisaCheckoutResult*)checkoutResult
                        completion:(void (^)(BTVisaCheckoutCardNonce * _Nullable tokenizedVisaCheckoutCard, NSError * _Nullable error))completion NS_SWIFT_NAME(tokenize(_:completion:));
@end

NS_ASSUME_NONNULL_END
