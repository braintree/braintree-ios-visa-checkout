#import "BraintreeDemoAppDelegate.h"
#import "BraintreeDemoSettings.h"
#import "BraintreeDemoSlideNavigationController.h"
#import "BraintreeDemoDemoContainmentViewController.h"
#import "BraintreeCore.h"
#import <VisaCheckoutSDK/VisaCheckoutSDK.h>

#if DEBUG
#import <FLEX/FLEXManager.h>
#endif

NSString *BraintreeDemoAppDelegatePaymentsURLScheme = @"com.braintreepayments.Demo.payments";

@implementation BraintreeDemoAppDelegate

- (BOOL)application:(__unused UIApplication *)application didFinishLaunchingWithOptions:(__unused NSDictionary *)launchOptions {
    [VisaCheckoutSDK configure];

    [self setupAppearance];
    [self registerDefaultsFromSettings];

    [BTAppSwitch setReturnURLScheme:BraintreeDemoAppDelegatePaymentsURLScheme];

    BraintreeDemoDemoContainmentViewController *rootViewController = [[BraintreeDemoDemoContainmentViewController alloc] init];
    BraintreeDemoSlideNavigationController *slideNav = [[BraintreeDemoSlideNavigationController alloc] initWithRootViewController:rootViewController];
    self.window = [[UIWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];
    self.window.rootViewController = slideNav;
    [self.window makeKeyAndVisible];
    return YES;
}

- (BOOL)application:(__unused UIApplication *)app openURL:(NSURL *)url options:(NSDictionary<NSString *,id> *)options {
    if ([[url.scheme lowercaseString] isEqualToString:[BraintreeDemoAppDelegatePaymentsURLScheme lowercaseString]]) {
        return [BTAppSwitch handleOpenURL:url options:options];
    }
    return YES;
}

- (void)setupAppearance {
    UIColor *pleasantGray = [UIColor colorWithWhite:42/255.0f alpha:1.0f];

    [[UIToolbar appearance] setBarTintColor:pleasantGray];
    [[UIToolbar appearance] setBarStyle:UIBarStyleBlackTranslucent];
}

- (void)registerDefaultsFromSettings {
    // Check for testing arguments
    if ([[[NSProcessInfo processInfo] arguments] containsObject:@"-EnvironmentSandbox"]) {
        [[NSUserDefaults standardUserDefaults] setInteger:BraintreeDemoTransactionServiceEnvironmentSandboxBraintreeSampleMerchant forKey:BraintreeDemoSettingsEnvironmentDefaultsKey];
    }else if ([[[NSProcessInfo processInfo] arguments] containsObject:@"-EnvironmentProduction"]) {
        [[NSUserDefaults standardUserDefaults] setInteger:BraintreeDemoTransactionServiceEnvironmentProductionExecutiveSampleMerchant forKey:BraintreeDemoSettingsEnvironmentDefaultsKey];
    }
    
    if ([[[NSProcessInfo processInfo] arguments] containsObject:@"-TokenizationKey"]) {
        [[NSUserDefaults standardUserDefaults] setBool:TRUE forKey:@"BraintreeDemoUseTokenizationKey"];
    }else if ([[[NSProcessInfo processInfo] arguments] containsObject:@"-ClientToken"]) {
        [[NSUserDefaults standardUserDefaults] setBool:FALSE forKey:@"BraintreeDemoUseTokenizationKey"];
        // Use random users for testing with Client Tokens
        [[NSUserDefaults standardUserDefaults] setObject:@"" forKey:@"BraintreeDemoCustomerIdentifier"];
    }
    
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"BraintreeDemoSettingsAuthorizationOverride"];
    for (NSString* arg in [[NSProcessInfo processInfo] arguments]) {
        if ([arg rangeOfString:@"-Integration:"].location != NSNotFound) {
            NSString* testIntegration = [arg stringByReplacingOccurrencesOfString:@"-Integration:" withString:@""];
            [[NSUserDefaults standardUserDefaults] setObject:testIntegration forKey:@"BraintreeDemoSettingsIntegration"];
        } else if ([arg rangeOfString:@"-Authorization:"].location != NSNotFound) {
            NSString* testIntegration = [arg stringByReplacingOccurrencesOfString:@"-Authorization:" withString:@""];
            [[NSUserDefaults standardUserDefaults] setObject:testIntegration forKey:@"BraintreeDemoSettingsAuthorizationOverride"];
        }
    }
    // End checking for testing arguments
    
    
    NSString *settingsBundle = [[NSBundle mainBundle] pathForResource:@"Settings" ofType:@"bundle"];
    if(!settingsBundle) {
        NSLog(@"Could not find Settings.bundle");
        return;
    }
    
    NSDictionary *settings = [NSDictionary dictionaryWithContentsOfFile:[settingsBundle stringByAppendingPathComponent:@"Root.plist"]];
    NSArray *preferences = [settings objectForKey:@"PreferenceSpecifiers"];
    
    NSMutableDictionary *defaultsToRegister = [[NSMutableDictionary alloc] initWithCapacity:[preferences count]];
    for (NSDictionary *prefSpecification in preferences) {
        NSString *key = [prefSpecification objectForKey:@"Key"];
        if(key && [[prefSpecification allKeys] containsObject:@"DefaultValue"]) {
            [defaultsToRegister setObject:[prefSpecification objectForKey:@"DefaultValue"] forKey:key];
        }
    }
    
    [[NSUserDefaults standardUserDefaults] registerDefaults:defaultsToRegister];
}


#if DEBUG
- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    [super touchesBegan:touches withEvent:event];
    CGPoint location = [[[event allTouches] anyObject] locationInView:[self window]];
    if(location.y > 0 && location.y < [[UIApplication sharedApplication] statusBarFrame].size.height) {
        [[FLEXManager sharedManager] showExplorer];
    }
}
#endif

@end
