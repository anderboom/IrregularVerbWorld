//
//  UIButton+Extension.swift
//  irregularVerbs
//
//  Created by MaksymHusar on 7/31/19.
//  Copyright © 2019 RK. All rights reserved.
//

import UIKit

extension UIButton {
    open override var isEnabled: Bool {
        didSet {
            alpha = isEnabled ? 1.0 : 0.35
        }
    }
}
