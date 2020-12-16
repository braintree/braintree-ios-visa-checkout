/**
 Copyright © 2018 Visa. All rights reserved.
 */

typedef void (^LaunchHandle)(void);
/// The closure to execute when Visa Checkout is finished configuring and is ready to launch (for manual configuration/launch).
typedef void (^ManualCheckoutReadyHandler)(LaunchHandle _Nonnull launchHandle);
typedef void (^ButtonTappedReadyHandler)(void);
