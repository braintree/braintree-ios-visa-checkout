# Braintree iOS Visa Checkout SDK Release Notes

## 5.0.0 (2020-12-29)

* Breaking changes
  * Update VisaCheckoutSDK to 7.2.0
  * Update minimum deployment target to iOS 12 and require Xcode 12

## 4.0.1 (2018-11-27)

* Update VisaCheckoutSDK to 6.6.1

## 4.0.0 (2018-10-03)

* Update VisaCheckoutSDK to 6.6.0
  * VisaCheckoutButton's `onCheckout` API changed from `onCheckout(profile:purchaseInfo:presenting:completion:)` to `onCheckout(profile:purchaseInfo:presenting:onReady:onButtonTapped:completion:)`

## 3.1.0 (2018-08-22)

* Update VisaCheckoutSDK to 6.3

## 3.0.0 (2018-06-06)

* Update VisaCheckoutSDK to 6.2
  * 6.2 will require updates to your Visa Checkout integration. Refer to Visa's developer documents for details.

## 2.0.1 (2018-03-01)

* Enable bitcode in project

## 2.0.0 (2018-01-03)

* Update VisaCheckoutSDK to 5.5.2 which is compatible with Xcode 9.2
  * Visa Checkout frameworks supplied by this library should be used to prevent version mismatch

## 1.0.0 (2017-04-14)

* First release candidate of the Braintree iOS Visa Checkout SDK.
  * This SDK component is currently in a limited release to [eligible merchants](https://articles.braintreepayments.com/guides/payment-methods/visa-checkout#limited-release-eligibility) and the API is subject to change.
