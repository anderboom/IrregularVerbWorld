//
//  TutorialView.swift
//  irregularVerbs
//
//  Created by Admin on 2/20/19.
//  Copyright © 2019 RK. All rights reserved.
//

import UIKit

class TutorialView: UIView {
    static func make() -> TutorialView {
        return Bundle.main.loadNibNamed(String(describing: self), owner: nil, options: nil)?.first as! TutorialView
    }
    
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet private weak var titleLabel: UILabel!
    @IBOutlet private weak var subtitleLabel: UILabel!
    
    func update(title: String, subtitle: String, image: UIImage) {
        titleLabel.text = title
        subtitleLabel.text = subtitle
        imageView.image = image
    }
}
