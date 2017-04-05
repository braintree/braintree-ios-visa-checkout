#import "BTVisaCheckoutUserData.h"

@implementation BTVisaCheckoutUserData

- (instancetype)initWithJSON:(BTJSON *)userDataJSON {
    if (self = [super init]) {
        _firstName = [userDataJSON[@"userFirstName"] asString];
        _lastName = [userDataJSON[@"userLastName"] asString];
        _fullName = [userDataJSON[@"userFullName"] asString];
        _username = [userDataJSON[@"userName"] asString];
        _email = [userDataJSON[@"userEmail"] asString];
    }

    return self;
}

+ (instancetype)userDataWithJSON:(BTJSON *)userDataJSON {
    return [[self alloc] initWithJSON:userDataJSON];
}

@end
