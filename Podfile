source 'https://github.com/CocoaPods/Specs.git'

platform :ios, '9.3'

workspace 'BraintreeVisaCheckout.xcworkspace'

target 'BraintreeVisaCheckout' do
    pod 'Braintree/Core', :path => '../braintree-ios'
end

target 'DemoVisaCheckout' do
  pod 'BraintreeVisaCheckout', :path => './'
  pod 'Braintree/Core', :path => '../braintree-ios'

  pod 'HockeySDK'
  pod 'AFNetworking', '~> 2.6.0'
  pod 'CardIO'
  pod 'NSURL+QueryDictionary', '~> 1.0'
  pod 'PureLayout'
  pod 'FLEX'
  pod 'InAppSettingsKit'
  pod 'iOS-Slide-Menu'
end

abstract_target 'Tests' do
  pod 'BraintreeVisaCheckout', :path => './'
  pod 'Braintree/Core', :path => '../braintree-ios'

  pod 'Specta'
  pod 'Expecta'
  pod 'OCMock'
  pod 'OHHTTPStubs'

  target 'BraintreeVisaCheckoutSwiftUnitTests'
  target 'BraintreeVisaCheckoutIntegrationTests'
end
