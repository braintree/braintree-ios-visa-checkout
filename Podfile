source 'https://cdn.cocoapods.org/'

platform :ios, '9.3'

workspace 'BraintreeVisaCheckout.xcworkspace'
use_frameworks!

target 'DemoVisaCheckout' do
  pod 'BraintreeVisaCheckout', :path => './'
  pod 'Braintree/Core'

  pod 'AFNetworking', '~> 2.6.0'
  pod 'NSURL+QueryDictionary', '~> 1.0'
  pod 'PureLayout'
  pod 'FLEX'
  pod 'InAppSettingsKit'
  pod 'iOS-Slide-Menu'
end

abstract_target 'Tests' do
  pod 'BraintreeVisaCheckout', :path => './'
  pod 'Braintree/Core'

  pod 'Specta'
  pod 'Expecta'
  pod 'OCMock'
  pod 'OHHTTPStubs'

  target 'UnitTests'
  target 'IntegrationTests'
end
