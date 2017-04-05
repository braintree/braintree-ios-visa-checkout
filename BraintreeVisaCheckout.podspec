Pod::Spec.new do |s|
  s.name             = "BraintreeVisaCheckout"
  s.version          = "4.7.5" # TODO: What version should this start at?
  s.summary          = "Braintree Visa Checkout component for use with the Braintree iOS SDK"
  s.description      = <<-DESC
                       Braintree is a full-stack payments platform for developers

                       This CocoaPod will help you accept payments in your iOS app.

                       Check out our development portal at https://developers.braintreepayments.com.
  DESC
  s.homepage         = "https://www.braintreepayments.com/how-braintree-works"
  s.documentation_url = "https://developers.braintreepayments.com/ios/start/hello-client"
  s.screenshots      = "https://raw.githubusercontent.com/braintree/braintree_ios/master/screenshot.png"
  s.license          = "MIT"
  s.author           = { "Braintree" => "code@getbraintree.com" }
  s.source           = { :git => "https://github.com/braintree/braintree_ios.git", :tag => s.version.to_s }
  s.social_media_url = "https://twitter.com/braintree"

  s.platform         = :ios, "9.3"
  s.requires_arc     = true
  s.compiler_flags = "-Wall -Werror -Wextra"

  s.default_subspecs = %w[BraintreeVisaCheckout]

  s.subspec "BraintreeVisaCheckout" do |s|
    s.source_files  = "BraintreeVisaCheckout/**/*.{h,m}"
    s.public_header_files = "BraintreeVisaCheckout/Public/*.h"
    s.frameworks = "UIKit"
    s.dependency "Braintree/Core", "~> 4.0"
  end
end

