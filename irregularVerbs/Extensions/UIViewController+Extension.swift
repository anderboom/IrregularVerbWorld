//
//  UIViewController+Extension.swift
//  irregularVerbs
//
//  Created by MaksymHusar on 5/21/19.
//  Copyright © 2019 RK. All rights reserved.
//

import UIKit

extension UIViewController {
    static func instantiateVC() -> Self {
        return UIStoryboard.storyboard(.main).instantiateViewController()
    }
}
