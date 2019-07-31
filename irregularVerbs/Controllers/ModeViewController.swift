//
//  ModeViewController.swift
//  irregularVerbs
//
//  Created by Admin on 5/18/19.
//  Copyright © 2019 RK. All rights reserved.
//

import UIKit
import GameKit
import MessageUI

class ModeViewController: UIViewController {

    @IBOutlet private weak var allOneByOneOutlet: UIButton!
    @IBOutlet private weak var allRandomlyOutlet: UIButton!
    @IBOutlet private weak var onlySelectedOutlet: UIButton!
    @IBOutlet private weak var removeAdsOutlet: UIButton!
    @IBOutlet private weak var leaderBoardOutlet: UIButton!
    @IBOutlet private weak var allWithSkipping: UIButton!
    private var gcEnabled = false {
        didSet {
            leaderBoardOutlet.isEnabled = gcEnabled
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        let allButtons: [UIButton] = [
            allOneByOneOutlet, allRandomlyOutlet, allWithSkipping,
            onlySelectedOutlet, removeAdsOutlet, leaderBoardOutlet, allWithSkipping
        ]
        allButtons.forEach { $0.layer.cornerRadius = $0.frame.height / 5.0 }
        
        authenticateLocalPlayer()
        
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(image: UIImage(named: "letter"), style: .plain,
                                                                 target: self, action: #selector(sendMail))
    }
    
    @objc private func sendMail() {
        guard MFMailComposeViewController.canSendMail() else {
            print("Can't send email")
            return
        }
        let mailComposeVC = MFMailComposeViewController()
        mailComposeVC.mailComposeDelegate = self
        mailComposeVC.setToRecipients(["irregularverbsworld@gmail.com"])
        mailComposeVC.setSubject("Suggestions and Recommendations")
        mailComposeVC.setMessageBody("", isHTML: false)
        self.present(mailComposeVC, animated: true, completion: nil)
    }
    
    @IBAction private func startAllOneByOnePressed(_ sender: UIButton) {
        sender.showsTouchWhenHighlighted = true
        let words = DataManager.instance.wordsArray
        let currentIndex = DataManager.instance.allOneByOneCurrentWordIndex
        let saveNewIndexAction: (Int) -> Void = { newIndex in
            DataManager.instance.allOneByOneCurrentWordIndex = newIndex
        }
        let viewModel = TrainingViewModel(words: words,
                                          iterateMode: .consistently(currentIndex: currentIndex),
                                          saveCurrentIndexChangeAction: saveNewIndexAction)
        startTraining(with: viewModel)
    }

    @IBAction private func startAllRandomlyPressed(_ sender: UIButton) {
        sender.showsTouchWhenHighlighted = true
        let words = DataManager.instance.wordsArray
        let viewModel = TrainingViewModel(words: words, iterateMode: .randomly)
        startTraining(with: viewModel)
    }
    
    @IBAction private func onlySelectedButtonPressed(_ sender: UIButton) {
        sender.showsTouchWhenHighlighted = true
    }
    
    @IBAction private func gameCenterButtonPressed(_ sender: UIButton) {
        sender.showsTouchWhenHighlighted = true
        showGameCenterLeaderBoard()
    }
    
    // MARK: - AUTHENTICATE LOCAL PLAYER
    private func authenticateLocalPlayer() {
        let localPlayer: GKLocalPlayer = GKLocalPlayer.local
        self.gcEnabled = localPlayer.isAuthenticated
        localPlayer.authenticateHandler = { [weak self] gcAuthVC, error in
            if localPlayer.isAuthenticated {
                print("User is authenticated")
                self?.gcEnabled = true
            } else if let vc = gcAuthVC {
                // 1. Show login if player is not logged in
                self?.present(vc, animated: true, completion: nil)
            } else {
                // 3. Game center is not enabled on the users device
                self?.gcEnabled = false
                print("Local player could not be authenticated! \(error?.localizedDescription ?? "")")
            }
        }
    }

   private func showGameCenterLeaderBoard() {
        let gcVC = GKGameCenterViewController()
        gcVC.gameCenterDelegate = self
        gcVC.viewState = .leaderboards
        gcVC.leaderboardIdentifier = Constants.GameCenter.leaderboardID
        present(gcVC, animated: true, completion: nil)
    }

   @IBAction private func removeAdsButtonPressed(_ sender: UIButton) {
        sender.showsTouchWhenHighlighted = true
    }
    
    private func startTraining(with viewModel: TrainingViewModel) {
        let destVC = TrainingViewController.instantiateVC()
        destVC.viewModel = viewModel
        navigationController?.pushViewController(destVC, animated: true)
    }
}

extension ModeViewController: GKGameCenterControllerDelegate {
    func gameCenterViewControllerDidFinish(_ gameCenterViewController: GKGameCenterViewController) {
        gameCenterViewController.dismiss(animated: true)
    }
}

extension ModeViewController: MFMailComposeViewControllerDelegate {
    func mailComposeController(_ controller: MFMailComposeViewController, didFinishWith result: MFMailComposeResult, error: Error?) {
        controller.dismiss(animated: true, completion: nil)
    }
    
}
