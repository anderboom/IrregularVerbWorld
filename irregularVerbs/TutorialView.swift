//
//  TutorialView.swift
//  irregularVerbs
//
//  Created by Admin on 2/20/19.
//  Copyright © 2019 RK. All rights reserved.
//

import UIKit

class TutorialView: UIView {
    
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var tutorialLabel: UILabel!
    @IBOutlet weak var nextButton: UIButton!
    var nextButtonPress: (() -> Void)?
    
    @IBAction func nextButtonPressed(_ sender: Any) {
        nextButtonPress?()
        
    }
}
