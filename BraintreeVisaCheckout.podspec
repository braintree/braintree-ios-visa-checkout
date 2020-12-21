Pod::Spec.new do |s|
  s.name             = "BraintreeVisaCheckout"
  s.version          = "4.0.1"
  s.summary          = "Braintree Visa Checkout component for use with the Braintree iOS SDK"
  s.description      = <<-DESC
                       Braintree is a full-stack payments platform for developers

                       This CocoaPod will help you accept Visa Checkout payments in your iOS app.

                       Check out our development portal at https://developers.braintreepayments.com.
  DESC
  s.homepage         = "https://www.braintreepayments.com/how-braintree-works"
  s.documentation_url = "https://developers.braintreepayments.com/guides/visa-checkout/overview"
  s.license          = "MIT"
  s.author           = { "Braintree" => "code@getbraintree.com" }
  s.source           = { :git => "https://github.com/braintree/braintree-ios-visa-checkout.git", :tag => s.version.to_s }

  s.platform         = :ios, "12.0"
  s.requires_arc     = true
  s.compiler_flags = "-Wall -Werror -Wextra"

  s.source_files  = "BraintreeVisaCheckout/**/*.{h,m}"
  s.public_header_files = "BraintreeVisaCheckout/Public/*.h"
  s.vendored_frameworks = "Frameworks/VisaCheckoutSDK.framework"
  s.dependency "Braintree/Core", "~> 4.0"

  # https://github.com/CocoaPods/CocoaPods/issues/10065#issuecomment-694266259
  s.pod_target_xcconfig = { 'EXCLUDED_ARCHS[sdk=iphonesimulator*]' => 'arm64' }
  s.user_target_xcconfig = { 'EXCLUDED_ARCHS[sdk=iphonesimulator*]' => 'arm64' }
end

