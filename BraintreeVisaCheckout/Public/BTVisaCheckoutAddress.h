#ifdef COCOAPODS
#import <Braintree/BraintreeCore.h>
#else
#import <BraintreeCore/BraintreeCore.h>
#endif

@interface BTVisaCheckoutAddress : NSObject

/*!
 @brief First name for the address.
 */
@property (nonatomic, nullable, readonly, copy) NSString *firstName;

/*!
 @brief LastName for the address.
 */
@property (nonatomic, nullable, readonly, copy) NSString *lastName;

/*!
 @brief Street address for the address.
 */
@property (nonatomic, nullable, readonly, copy) NSString *streetAddress;

/*!
 @brief Extended address for the address.
 */
@property (nonatomic, nullable, readonly, copy) NSString *extendedAddress;

/*!
 @brief Locality for the address.
 */
@property (nonatomic, nullable, readonly, copy) NSString *locality;

/*!
 @brief Region for the address.
 */
@property (nonatomic, nullable, readonly, copy) NSString *region;

/*!
 @brief Postal code for the address.
 */
@property (nonatomic, nullable, readonly, copy) NSString *postalCode;

/*!
 @brief Country code for the address.
 */
@property (nonatomic, nullable, readonly, copy) NSString *countryCode;

/*!
 @brief Phone number for the address.
 */
@property (nonatomic, nullable, readonly, copy) NSString *phoneNumber;

#pragma mark - Internal

+ (nonnull instancetype)addressWithJSON:(nonnull BTJSON *)addressJSON;


@end
