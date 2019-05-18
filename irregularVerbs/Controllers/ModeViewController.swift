//
//  ModeViewController.swift
//  irregularVerbs
//
//  Created by Admin on 5/18/19.
//  Copyright © 2019 RK. All rights reserved.
//

import UIKit

class ModeViewController: UIViewController {

    @IBOutlet private weak var allOneByOneOutlet: UIButton!
    @IBOutlet private weak var allRandomlyOutlet: UIButton!
    @IBOutlet private weak var allWithSkippingOutlet: UIButton!
    @IBOutlet private weak var onlySelectedOutlet: UIButton!
    @IBOutlet private weak var removeAdsOutlet: UIButton!
    @IBOutlet private weak var leaderBoardOutlet: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        allOneByOneOutlet.layer.cornerRadius = allOneByOneOutlet.frame.size.height / 5.0
        allRandomlyOutlet.layer.cornerRadius = allRandomlyOutlet.frame.size.height / 5.0
        allWithSkippingOutlet.layer.cornerRadius = allWithSkippingOutlet.frame.size.height / 5.0
        onlySelectedOutlet.layer.cornerRadius = onlySelectedOutlet.frame.size.height / 5.0
        removeAdsOutlet.layer.cornerRadius = removeAdsOutlet.frame.size.height / 5.0
        leaderBoardOutlet.layer.cornerRadius = leaderBoardOutlet.frame.size.height / 5.0
    }
    
@IBAction func backToModeController(_ segue: UIStoryboardSegue) { }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard segue.identifier == "OneByOneToTraining" else {return}
        guard let destVC = segue.destination as? TrainingViewController else { return }
        destVC.setup(words: DataManager.instance.wordsArray, startIndex: DataManager.instance.indexValue)
    }
}
