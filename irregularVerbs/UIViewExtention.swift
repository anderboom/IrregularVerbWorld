//
//  UIViewExtention.swift
//  irregularVerbs
//
//  Created by Admin on 1/22/19.
//  Copyright © 2019 RK. All rights reserved.
//

import Foundation
import  UIKit

extension UIView {
    public func removeAllSubViews() {
        self.subviews.forEach({ $0.removeFromSuperview() })
    }
}

extension Collection where Element: Hashable {
    var orderedSet: [Element] {
        var set: Set<Element> = []
        return reduce(into: []) { set.insert($1).inserted ? $0.append($1) : () }
    }
}
