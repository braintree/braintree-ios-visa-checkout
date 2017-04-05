#import "BTConfiguration+VisaCheckout.h"

@implementation BTConfiguration (VisaCheckout)

/// Indicates whether Visa Checkout is enabled for the merchant account.
- (BOOL)isVisaCheckoutEnabled {
    return [self.json[@"visaCheckout"] isObject] && [[self visaCheckoutAPIKey] length];
}

/// Returns the Visa Checkout API key configured in the Braintree Control Panel
- (NSString *)visaCheckoutAPIKey {
    return [self.json[@"visaCheckout"][@"apikey"] asString]; // lowercase k
}

/// Returns the Visa Checkout External Client ID configured in the Braintree Control Panel
- (NSString *)visaCheckoutExternalClientId {
    return [self.json[@"visaCheckout"][@"externalClientId"] asString];
}

/// Returns the Visa Checkout supported networks enabled for the merchant account.
- (NSArray<NSNumber *> *)visaCheckoutSupportedNetworks {
    NSMutableArray <NSNumber *> *visaCheckoutSupportedNetworks = [NSMutableArray new];
    NSArray *supportedCardTypes = [self.json[@"visaCheckout"][@"supportedCardTypes"] asStringArray];
    for (NSString *cardType in supportedCardTypes) {
        if ([cardType isEqualToString:@"Visa"]) {
            [visaCheckoutSupportedNetworks addObject:@(0)];
        } else if ([cardType isEqualToString:@"MasterCard"]) {
            [visaCheckoutSupportedNetworks addObject:@(1)];
        } else if ([cardType isEqualToString:@"American Express"]) {
            [visaCheckoutSupportedNetworks addObject:@(2)];
        } else if ([cardType isEqualToString:@"Discover"]) {
            [visaCheckoutSupportedNetworks addObject:@(3)];
        }
    }
    return [visaCheckoutSupportedNetworks copy];
}

@end
