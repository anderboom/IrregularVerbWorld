//
//  ListTableViewCell.swift
//  irregularVerbs
//
//  Created by Admin on 1/4/19.
//  Copyright © 2019 RK. All rights reserved.
//

import UIKit

class ListTableViewCell: UITableViewCell {

    static let identifier = String(describing: ListTableViewCell.self)
    static let nib = UINib(nibName: String(describing: ListTableViewCell.self), bundle: nil)

    @IBOutlet private weak var firstFormLabel: UILabel!
    @IBOutlet private weak var secondFormLabel: UILabel!
    @IBOutlet private weak var thirdFormLabel: UILabel!
    @IBOutlet private weak var translatingLabel: UILabel!
    @IBOutlet private weak var playButtonOutlet: UIButton!
//    var addToHistoryAction: (() -> Void)?
    var playCurrentWordAction: (() -> Void)?
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
//    @IBAction private func addToHistory(_ sender: UIButton) {
//        addToHistoryAction?()
//    }
    
    @IBAction private func playCurrentWords(_ sender: UIButton) {
        playCurrentWordAction?()
    }
    
    func update(firstForm: String, secondForm: String,
                thirdForm: String, translation: String) {
        firstFormLabel.text = firstForm
        secondFormLabel.text = secondForm
        thirdFormLabel.text = thirdForm
        translatingLabel.text = translation
    }
}
