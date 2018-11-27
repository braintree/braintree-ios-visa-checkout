# Braintree iOS Visa Checkout SDK

Welcome to Braintree's iOS Visa Checkout SDK. This library will help you accept Visa Checkout payments in your iOS app.

**The Braintree iOS Visa Checkout SDK is currently in a limited release and the API is subject to change.**

**The Braintree iOS Visa Checkout SDK requires Xcode 9.2, Base SDK of iOS 9.0+, and Visa Checkout SDK for iOS v6.6.1**. It permits a Deployment Target of iOS 9.0 or higher.

## Getting Started

We recommend using [CocoaPods](https://github.com/CocoaPods/CocoaPods) to integrate the Braintree iOS Visa Checkout SDK with your project.

The Visa Checkout iOS SDK is also required, and available through this repository. Reference the [Visa Checkout](#visa-checkout) section for details on accessing the Visa Checkout iOS SDK.

### CocoaPods

Add to your `Podfile`:
```
pod 'BraintreeVisaCheckout'
```
Then run `pod install`. This includes everything you need to accept Visa Checkout payments.

Customize your integration by specifying additional components. For example, to add Apple Pay support:
```
pod 'BraintreeVisaCheckout'
pod 'Braintree/Apple-Pay'
```

See our [`Podspec`](Braintree.podspec) for more information.

## Documentation

Start with [**'Hello, Client!'**](https://developers.braintreepayments.com/ios/start/hello-client) for instructions on basic setup and usage.

Next, read the [**full documentation on Braintree Visa Checkout**](https://developers.braintreepayments.com/guides/visa-checkout/overview) for information about the Visa Checkout integration and tokenization.

Finally, [**cocoadocs.org/docsets/BraintreeVisaCheckout**](http://cocoadocs.org/docsets/BraintreeVisaCheckout) hosts the complete, up-to-date API documentation generated straight from the header files.

## Demo

A demo app is included in project. To run it, run `pod install` and then open `BraintreeVisaCheckout.xcworkspace` in Xcode.

## Visa Checkout

The [VisaCheckout.framework and TrustDefender.framework](/VisaCheckout_IOS_SDK) are included when cloning this SDK. Cocoapods will auto import these frameworks for your use.

## Help

* Read the headers
* [Read the docs](https://developers.braintreepayments.com/ios/sdk/client)
* Find a bug? [Open an issue](https://github.com/braintree/braintree-ios-visa-checkout/issues)
* Want to contribute? [Check out contributing guidelines](CONTRIBUTING.md) and [submit a pull request](https://help.github.com/articles/creating-a-pull-request).

## Feedback

The Braintree iOS Visa Checkout SDK is in active development, we welcome your feedback!

Here are a few ways to get in touch:

* [GitHub Issues](https://github.com/braintree/braintree-ios-visa-checkout/issues) - For generally applicable issues and feedback
* [Braintree Support](https://articles.braintreepayments.com/) / support@braintreepayments.com - for personal support at any phase of integration

## Releases

Subscribe to our [Google Group](https://groups.google.com/forum/#!forum/braintree-sdk-announce) to
be notified when SDK releases go out.

### License

The Braintree iOS Visa Checkout SDK is open source and available under the MIT license. See the [LICENSE](LICENSE) file for more info.
