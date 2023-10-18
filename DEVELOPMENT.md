# Braintree iOS Visa Checkout Development Notes

This document outlines development practices that we follow internally while developing this SDK.

## Tests

There are a number of test targets for each section of the project. You can run the following test schemes via Xcode:

- `UITests`
- `IntegrationTests`
- `UnitTests`

## Environmental Assumptions

* See [Requirements](https://developer.paypal.com/braintree/docs/guides/client-sdk/setup/ios/v5#requirements)
* iPhone and iPad of all sizes and resolutions and the Simulator
* CocoaPods
* `BT` namespace is reserved for Braintree
* Host app does not integrate the [PayPal iOS SDK](https://github.com/paypal/paypal-ios-sdk)
* Host app does not integrate with the Kount SDK
* Host app does not integrate with [card.io](https://www.card.io/)
* Host app has a secure, authenticated server with a [Braintree server-side integration](https://developer.paypal.com/braintree/docs/start/hello-server)

## Committing

* Commits should be small but atomic. Tests should always be passing; the product should always function appropriately.
* Commit messages should be concise and descriptive.
* Commit messages may reference the trello board by ID or URL. (Sorry, these are not externally viewable.)

## Deployment and Code Organization

* Code on master is assumed to be in a relatively good state at all times
  * Tests should be passing, all demo apps should run
  * Functionality and user experience should be cohesive
  * Dead code should be kept to a minimum
* Versioned deployments are tagged with their version numbers
  * Version numbers conform to [SEMVER](http://semver.org)
  * These versions are more heavily tested
  * We will provide support for these versions and commit to maintaining backwards compatibility on our servers
* Pull requests are welcome
  * Feel free to create an issue on GitHub before investing development time
* As needed, the Braintree team may develop features privately
  * If our internal and public branches get out of sync, we will reconcile this with merges (as opposed to rebasing)
  * In general, we will try to develop in the open as much as possible

## Releasing

To release a new version of the SDK publicly, run the GitHub Action release workflow and specify the correct semantic version number.