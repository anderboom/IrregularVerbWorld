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
    private var gcEnabled = Bool()
    private var gcDefaultLeaderBoard = String()
    private let LEADERBOARD_ID = "com.andrewgusar.irregularVerbsWorld.Scores"

    override func viewDidLoad() {
        super.viewDidLoad()
        allOneByOneOutlet.layer.cornerRadius = allOneByOneOutlet.frame.size.height / 5.0
        allRandomlyOutlet.layer.cornerRadius = allRandomlyOutlet.frame.size.height / 5.0
        allWithSkipping.layer.cornerRadius = allWithSkipping.frame.size.height / 5.0
        onlySelectedOutlet.layer.cornerRadius = onlySelectedOutlet.frame.size.height / 5.0
        removeAdsOutlet.layer.cornerRadius = removeAdsOutlet.frame.size.height / 5.0
        leaderBoardOutlet.layer.cornerRadius = leaderBoardOutlet.frame.size.height / 5.0
         allWithSkipping.layer.cornerRadius = allWithSkipping.frame.size.height / 5.0
        StoreReviewHelper.checkAndAskForReview()
        authenticateLocalPlayer()
        
        let imageView = UIImageView(image: UIImage(named: "letter"))
        let buttonItem = UIBarButtonItem(customView: imageView)
        self.navigationItem.rightBarButtonItem = buttonItem
//        if !MFMailComposeViewController.canSendMail() {
//            print("Mail services are not available")
//            return
//        }
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(image: UIImage(named:"letter"), style: .plain, target: self, action: #selector(sendMail))
    }
    
    @objc private func sendMail () {
        let mailComposeViewController = configureMailComposer()
        if MFMailComposeViewController.canSendMail(){
            self.present(mailComposeViewController, animated: true, completion: nil)
        }else{
            print("Can't send email")
        }
    }
  
    func configureMailComposer() -> MFMailComposeViewController{
        let mailComposeVC = MFMailComposeViewController()
        mailComposeVC.mailComposeDelegate = self
        mailComposeVC.setToRecipients(["email_address@example.com"])
        mailComposeVC.setSubject("Hello World!")
        mailComposeVC.setMessageBody("Hello from iOS!", isHTML: false)
        return mailComposeVC
    }
    
    @IBAction private func startAllOneByOnePressed(_ sender: UIButton) {
        sender.showsTouchWhenHighlighted = true
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
       gameCenterLeaderBoardShow()
    }
    
    // MARK: - AUTHENTICATE LOCAL PLAYER
    private func authenticateLocalPlayer() {
        let localPlayer: GKLocalPlayer = GKLocalPlayer.local

        localPlayer.authenticateHandler = {[unowned self](ViewController, error) -> Void in
            if((ViewController) != nil) {
            
                // 1. Show login if player is not logged in
                self.present(ViewController!, animated: true, completion: nil)
                
            } else if (localPlayer.isAuthenticated) {
                print("User is authenticated")
            } else {
                // 3. Game center is not enabled on the users device
                self.gcEnabled = false
                print("Local player could not be authenticated!")
                print(error ?? "Error")
            }
        }
    }

   private func gameCenterLeaderBoardShow() {
        let gcVC = GKGameCenterViewController()
        gcVC.gameCenterDelegate = self
        gcVC.viewState = .leaderboards
        gcVC.leaderboardIdentifier = LEADERBOARD_ID
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
