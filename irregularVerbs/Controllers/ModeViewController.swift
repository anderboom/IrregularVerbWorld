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
    @IBOutlet private weak var backButtonOutlet: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        allOneByOneOutlet.layer.cornerRadius = allOneByOneOutlet.frame.size.height / 5.0
        allRandomlyOutlet.layer.cornerRadius = allRandomlyOutlet.frame.size.height / 5.0
        allWithSkippingOutlet.layer.cornerRadius = allWithSkippingOutlet.frame.size.height / 5.0
        onlySelectedOutlet.layer.cornerRadius = onlySelectedOutlet.frame.size.height / 5.0
        removeAdsOutlet.layer.cornerRadius = removeAdsOutlet.frame.size.height / 5.0
        leaderBoardOutlet.layer.cornerRadius = leaderBoardOutlet.frame.size.height / 5.0
        backButtonOutlet.layer.cornerRadius = backButtonOutlet.frame.size.height / 5.0
    }
    
    @IBAction func backToModeController(_ segue: UIStoryboardSegue) { }
    
    @IBAction private func startAllOneByOnePressed(_ sender: Any) {
        let words = DataManager.instance.wordsArray
        let currentIndex = DataManager.instance.indexValue
        let saveNewIndexAction: (Int) -> Void = { newIndex in
            DataManager.instance.indexValue = newIndex
        }
        let viewModel = TrainingViewModel(words: words,
                                          iterateMode: .consistently(currentIndex: currentIndex),
                                          saveCurrentIndexChangeAction: saveNewIndexAction)
        startTraining(with: viewModel)
    }

    @IBAction private func startAllRandomlyPressed(_ sender: Any) {
        let words = DataManager.instance.wordsArray
        let viewModel = TrainingViewModel(words: words, iterateMode: .randomly)
        startTraining(with: viewModel)
    }
    
    private func startTraining(with viewModel: TrainingViewModel) {
        let destVC = TrainingViewController.instantiateVC()
        destVC.viewModel = viewModel
        navigationController?.pushViewController(destVC, animated: true)
    }
    
}
