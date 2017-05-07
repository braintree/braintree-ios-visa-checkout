/**
 Copyright © 2017 Visa. All rights reserved.
 */

import UIKit
import VisaCheckoutSDK

@IBDesignable @objc
class VisaCheckoutButton: CheckoutButton {
    @IBInspectable open override var standardStyle: Bool {
        get { return super.standardStyle }
        set { super.standardStyle = newValue }
    }
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
}
