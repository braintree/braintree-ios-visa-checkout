#import "BTVisaCheckoutAddress.h"

@implementation BTVisaCheckoutAddress

- (instancetype)initWithJSON:(BTJSON *)addressJSON {
    if (self = [super init]) {
        _firstName = [addressJSON[@"firstName"] asString];
        _lastName = [addressJSON[@"lastName"] asString];
        _streetAddress = [addressJSON[@"streetAddress"] asString];
        _extendedAddress = [addressJSON[@"extendedAddress"] asString];
        _locality = [addressJSON[@"locality"] asString];
        _region = [addressJSON[@"region"] asString];
        _postalCode = [addressJSON[@"postalCode"] asString];
        _countryCode = [addressJSON[@"countryCode"] asString];
        _phoneNumber = [addressJSON[@"phoneNumber"] asString];
    }

    return self;
}

+ (instancetype)addressWithJSON:(BTJSON *)addressJSON {
    return [[self alloc] initWithJSON:addressJSON];
}

@end
