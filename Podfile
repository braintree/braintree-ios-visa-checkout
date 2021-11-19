source 'https://cdn.cocoapods.org/'

platform :ios, '12.0'

workspace 'BraintreeVisaCheckout.xcworkspace'
use_frameworks!
inhibit_all_warnings!

target 'DemoVisaCheckout' do
  pod 'BraintreeVisaCheckout', :path => './', :inhibit_warnings => false
  pod 'Braintree/Core', :inhibit_warnings => false

  pod 'AFNetworking', '~> 2.6.0'
  pod 'NSURL+QueryDictionary', '~> 1.0'
  pod 'PureLayout'
  pod 'FLEX'
  pod 'InAppSettingsKit', '~> 2.9'
  pod 'iOS-Slide-Menu'
  pod 'xcbeautify'
end

abstract_target 'Tests' do
  pod 'BraintreeVisaCheckout', :path => './', :inhibit_warnings => false
  pod 'Braintree/Core', :inhibit_warnings => false

  pod 'Specta'
  pod 'Expecta'
  pod 'OCMock'
  pod 'OHHTTPStubs', '~> 6.0'

  target 'UnitTests'
  target 'IntegrationTests'
end

# https://github.com/CocoaPods/CocoaPods/issues/7314
post_install do |pi|
  pi.pods_project.targets.each do |t|
    t.build_configurations.each do |config|
      config.build_settings['IPHONEOS_DEPLOYMENT_TARGET'] = '12.0'
    end
  end
end
