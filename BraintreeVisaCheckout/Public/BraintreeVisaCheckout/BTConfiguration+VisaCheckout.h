#ifdef COCOAPODS
#import <Braintree/BraintreeCore.h>
#else
#import <BraintreeCore/BraintreeCore.h>
#endif

@interface BTConfiguration (VisaCheckout)

/*!
 @brief Indicates whether Visa Checkout is enabled for the merchant account.
 */
@property (nonatomic, readonly, assign) BOOL isVisaCheckoutEnabled;

/*!
 @brief Returns the Visa Checkout supported networks enabled for the merchant account.
 */
@property (nonatomic, readonly, assign) NSArray <NSNumber *> *visaCheckoutSupportedNetworks;

/*!
 @brief Returns the Visa Checkout API key configured in the Braintree Control Panel.
 */
@property (nonatomic, readonly, copy) NSString *visaCheckoutAPIKey;

/*!
 @brief Returns the Visa Checkout External Client ID configured in the Braintree Control Panel.
 */
@property (nonatomic, readonly, copy) NSString *visaCheckoutExternalClientId;

@end
