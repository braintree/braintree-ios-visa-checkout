#ifdef COCOAPODS
#import <Braintree/BraintreeCore.h>
#else
#import <BraintreeCore/BraintreeCore.h>
#endif

@interface BTVisaCheckoutUserData : NSObject

+ (nonnull instancetype)userDataWithJSON:(nonnull BTJSON *)userDataJSON;

/*!
 @brief The user's first name.
 */
@property (nonatomic, nullable, readonly, copy) NSString *firstName;

/*!
 @brief The user's last name.
 */
@property (nonatomic, nullable, readonly, copy) NSString *lastName;

/*!
 @brief The user's full name.
 */
@property (nonatomic, nullable, readonly, copy) NSString *fullName;

/*!
 @brief The user's username.
 */
@property (nonatomic, nullable, readonly, copy) NSString *username;

/*!
 @brief The user's email.
 */
@property (nonatomic, nullable, readonly, copy) NSString *email;


@end
