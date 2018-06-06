#import "BraintreeDemoVisaCheckoutViewController.h"
#import <BraintreeVisaCheckout/BraintreeVisaCheckout.h>
#import <UIKit/UIKit.h>
#import <VisaCheckoutSDK/VisaCheckout.h>
#import "BTConfiguration.h"
#import "BTConfiguration+VisaCheckout.h"

@interface BraintreeDemoVisaCheckoutViewController ()
@property (nonatomic, strong) BTVisaCheckoutClient *client;

@end

@implementation BraintreeDemoVisaCheckoutViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    self.title = @"Visa Checkout";
    self.edgesForExtendedLayout = UIRectEdgeBottom;

    self.client = [[BTVisaCheckoutClient alloc] initWithAPIClient:self.apiClient];
    [self.client createProfile:^(VisaProfile * _Nullable profile, NSError * _Nullable error) {
        if (error) {
            NSLog(@"Failed to create Visa profile: %@", error);
            return;
        }

        profile.displayName = @"My App";

        VisaCurrencyAmount *currencyAmount = [[VisaCurrencyAmount alloc] initWithString:@"22.09"];
        VisaPurchaseInfo *purchaseInfo = [[VisaPurchaseInfo alloc] initWithTotal:currencyAmount currency:VisaCurrencyUsd];
        purchaseInfo.shippingRequired = true;

        VisaCheckoutButton *checkoutButton = [[VisaCheckoutButton alloc] initWithFrame:CGRectMake(0, 0, 213, 47)];
        [self.paymentButton addSubview:checkoutButton];

        [checkoutButton onCheckoutWithProfile:profile purchaseInfo:purchaseInfo presentingViewController:self completion:^(VisaCheckoutResult * _Nonnull result) {
            NSLog(@"Tokenizing VisaCheckoutResult...");
            [self.client tokenizeVisaCheckoutResult:result completion:^(BTVisaCheckoutCardNonce * _Nullable tokenizedVisaCheckoutCard, NSError * _Nullable error) {
                if (error) {
                    self.progressBlock([NSString stringWithFormat:@"Error tokenizing Visa Checkout card: %@", error.localizedDescription]);
                } else if (tokenizedVisaCheckoutCard) {
                    self.completionBlock(tokenizedVisaCheckoutCard);
                } else {
                    self.progressBlock(@"User canceled.");
                }
            }];
        }];
    }];
}

#pragma mark - Overrides

- (UIView *)createPaymentButton {
    return [[UIView alloc] initWithFrame:CGRectMake(0, 0, 213, 47)];
}

@end
