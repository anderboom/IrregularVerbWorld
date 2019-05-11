//
//  PurchaseTableViewCell.swift
//  irregularVerbs
//
//  Created by Admin on 4/19/19.
//  Copyright © 2019 RK. All rights reserved.
//

import UIKit

class PurchaseTableViewCell: UITableViewCell {
    
    @IBOutlet private weak var purchaseTextLabel: UILabel!
    static let identifier = String(describing: PurchaseTableViewCell.self)
    static let nib = UINib(nibName: String(describing: PurchaseTableViewCell.self), bundle: nil)
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    func update(purchaseText: String) {
        purchaseTextLabel.text = purchaseText
    }
    
}
