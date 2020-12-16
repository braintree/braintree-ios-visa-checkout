source 'https://cdn.cocoapods.org/'

platform :ios, '9.3'

workspace 'BraintreeVisaCheckout.xcworkspace'
use_frameworks!

target 'DemoVisaCheckout' do
  pod 'BraintreeVisaCheckout', :path => './'
  pod 'Braintree/Core'

  pod 'AFNetworking', '~> 2.6.0', :inhibit_warnings => true
  pod 'NSURL+QueryDictionary', '~> 1.0', :inhibit_warnings => true
  pod 'PureLayout', :inhibit_warnings => true
  pod 'FLEX', :inhibit_warnings => true
  pod 'InAppSettingsKit', '~> 2.9', :inhibit_warnings => true
  pod 'iOS-Slide-Menu', :inhibit_warnings => true
end

abstract_target 'Tests' do
  pod 'BraintreeVisaCheckout', :path => './'
  pod 'Braintree/Core'

  pod 'Specta'
  pod 'Expecta'
  pod 'OCMock'
  pod 'OHHTTPStubs', '~> 6.0'

  target 'UnitTests'
  target 'IntegrationTests'
end
