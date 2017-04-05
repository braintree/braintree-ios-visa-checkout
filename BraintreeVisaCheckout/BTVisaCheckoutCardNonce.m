#import "BTVisaCheckoutCardNonce.h"

@implementation BTVisaCheckoutCardNonce

- (instancetype)initWithNonce:(NSString *)nonce
                         type:(NSString *)type
                  description:(NSString *)description
                      lastTwo:(NSString *)lastTwo
                     cardNetwork:(BTCardNetwork)cardNetwork
                    isDefault:(BOOL)isDefault
              shippingAddress:(BTVisaCheckoutAddress *)shippingAddress
               billingAddress:(BTVisaCheckoutAddress *)billingAddress
                     userData:(BTVisaCheckoutUserData *)userData {
    if (self = [super initWithNonce:nonce
               localizedDescription:description
                               type:type
                          isDefault:isDefault]) {
        _lastTwo = lastTwo;
        _cardNetwork = cardNetwork;
        _shippingAddress = shippingAddress;
        _billingAddress = billingAddress;
        _userData = userData;
    }
    return self;
}

+ (BTCardNetwork)cardNetworkFromString:(BTJSON *)cardType {
    return [cardType asEnum:@{
                       @"american express": @(BTCardNetworkAMEX),
                       @"diners club": @(BTCardNetworkDinersClub),
                       @"unionpay": @(BTCardNetworkUnionPay),
                       @"discover": @(BTCardNetworkDiscover),
                       @"maestro": @(BTCardNetworkMaestro),
                       @"mastercard": @(BTCardNetworkMasterCard),
                       @"jcb": @(BTCardNetworkJCB),
                       @"laser": @(BTCardNetworkLaser),
                       @"solo": @(BTCardNetworkSolo),
                       @"switch": @(BTCardNetworkSwitch),
                       @"uk maestro": @(BTCardNetworkUKMaestro),
                       @"visa": @(BTCardNetworkVisa),}
                  orDefault:BTCardNetworkUnknown];
}

+ (instancetype)visaCheckoutCardNonceWithJSON:(BTJSON *)visaCheckoutJSON {
    NSDictionary *details = [visaCheckoutJSON[@"details"] asDictionary];
    BTJSON *cardType = [[BTJSON alloc] initWithValue:[visaCheckoutJSON[@"details"][@"cardType"] asString].lowercaseString];
    BTVisaCheckoutAddress *shippingAddress = [BTVisaCheckoutAddress addressWithJSON:visaCheckoutJSON[@"shippingAddress"]];
    BTVisaCheckoutAddress *billingAddress = [BTVisaCheckoutAddress addressWithJSON:visaCheckoutJSON[@"billingAddress"]];
    BTVisaCheckoutUserData *userData = [BTVisaCheckoutUserData userDataWithJSON:visaCheckoutJSON[@"userData"]];
    BTCardNetwork cardNetwork = [self cardNetworkFromString:cardType];

    return [[[self class] alloc] initWithNonce:[visaCheckoutJSON[@"nonce"] asString]
                                          type:[visaCheckoutJSON[@"type"] asString]
                                   description:[visaCheckoutJSON[@"description"] asString]
                                       lastTwo:details[@"lastTwo"]
                                      cardNetwork:cardNetwork
                                     isDefault:[visaCheckoutJSON[@"default"] isTrue]
                               shippingAddress:shippingAddress
                                billingAddress:billingAddress
                                      userData:userData];
}

@end
