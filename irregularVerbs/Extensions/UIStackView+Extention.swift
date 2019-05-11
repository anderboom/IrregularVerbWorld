//
//  UIStackView+Extention.swift
//  irregularVerbs
//
//  Created by Admin on 1/22/19.
//  Copyright © 2019 RK. All rights reserved.
//

import UIKit

extension UIStackView {
    public func removeAllSubViews() {
        self.subviews.forEach {
            self.removeArrangedSubview($0)
            $0.removeFromSuperview()
        }
    }
}
