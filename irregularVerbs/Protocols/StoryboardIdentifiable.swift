//
//  StoryboardIdentifiable.swift
//  irregularVerbs
//
//  Created by MaksymHusar on 5/11/19.
//  Copyright © 2019 RK. All rights reserved.
//

import UIKit

protocol StoryboardIdentifiable {
    static var storyboardIdentifier: String { get }
}

extension StoryboardIdentifiable where Self: UIViewController {
    static var storyboardIdentifier: String {
        return String(describing: self)
    }
}

extension UIViewController: StoryboardIdentifiable { }
