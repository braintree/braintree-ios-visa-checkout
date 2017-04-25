#if __has_include("BraintreeCore.h")
#import "BraintreeCore.h"
#endif

#if __has_include(<BraintreeCore/BraintreeCore.h>)
#import <BraintreeCore/BraintreeCore.h>
#endif

#if __has_include(<Braintree/BraintreeCore.h>)
#import <Braintree/BraintreeCore.h>
#endif

#import "BTVisaCheckoutAddress.h"
#import "BTVisaCheckoutUserData.h"

NS_ASSUME_NONNULL_BEGIN

@interface BTVisaCheckoutCardNonce : BTPaymentMethodNonce

/*!
 @brief The last two numbers on the payer's credit card.
 */
@property (nonatomic, nullable, readonly, copy) NSString *lastTwo;

/*!
 @brief The card network.
 */
@property (nonatomic, readonly, assign) BTCardNetwork cardNetwork;

/*!
 @brief The shipping address.
 */
@property (nonatomic, nullable, readonly, copy) BTVisaCheckoutAddress *shippingAddress;

/*!
 @brief The billing address.
 */
@property (nonatomic, nullable, readonly, copy) BTVisaCheckoutAddress *billingAddress;

/*!
 @brief Data about the Visa Checkout customer.
 */
@property (nonatomic, nullable, readonly, copy) BTVisaCheckoutUserData *userData;

/*!
 @brief Create a `BTVisaCheckoutCardNonce` object from JSON.
 */
+ (instancetype)visaCheckoutCardNonceWithJSON:(BTJSON *)visaCheckoutJSON;

@end

NS_ASSUME_NONNULL_END
