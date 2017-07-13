#import "BTVisaCheckoutClient.h"

@interface BTVisaCheckoutClient ()

/// Exposed for testing to get the instance of BTAPIClient
@property (nonnull, nonatomic, strong) BTAPIClient *apiClient;

/// Exposed for testing properties of the VisaCheckoutResult
- (void)tokenizeVisaCheckoutResult:(VisaCheckoutResultStatus)statusCode
                            callId:(nullable NSString *)callId
                      encryptedKey:(nullable NSString *)encryptedKey
              encryptedPaymentData:(nullable NSString *)encryptedPaymentData
                        completion:(nonnull void (^)(BTVisaCheckoutCardNonce * _Nullable, NSError * _Nullable))completion
NS_SWIFT_NAME(tokenize(_:callId:encryptedKey:encryptedPaymentData:completion:));

@end
