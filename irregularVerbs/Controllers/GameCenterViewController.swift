//
//  GameCenterViewController.swift
//  irregularVerbs
//
//  Created by Admin on 7/20/19.
//  Copyright © 2019 RK. All rights reserved.
//

import UIKit
import GameKit

class GameCenterViewController: UIViewController {
   
    @IBOutlet private weak var scoreLabel: UILabel!
    @IBOutlet private weak var addScoreButtonLabel: UIButton!
    @IBOutlet private weak var gameCenterButtonLabel: UIButton!
    var gcEnabled = Bool()
    var gcDefaultLeaderBoard = String()
    var score = DataManager.instance.commonScore
    let LEADERBOARD_ID = "com.andrewgusar.irregularVerbsWorld.Scores"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        addScoreButtonLabel.layer.cornerRadius = addScoreButtonLabel.frame.size.height / 5.0
        gameCenterButtonLabel.layer.cornerRadius = gameCenterButtonLabel.frame.size.height / 5.0
        authenticateLocalPlayer()
        scoreLabel.text = String(score)
    }
    
    // MARK: - AUTHENTICATE LOCAL PLAYER
    func authenticateLocalPlayer() {
        let localPlayer: GKLocalPlayer = GKLocalPlayer.local
        
        localPlayer.authenticateHandler = {(ViewController, error) -> Void in
            if((ViewController) != nil) {
                // 1. Show login if player is not logged in
                self.present(ViewController!, animated: true, completion: nil)
            } else if (localPlayer.isAuthenticated) {
                // 2. Player is already authenticated & logged in, load game center
                self.gcEnabled = true
                
                // Get the default leaderboard ID
                localPlayer.loadDefaultLeaderboardIdentifier(completionHandler: { (leaderboardIdentifer, error) in
                    if error != nil { print(error ?? "Error")
                    } else { self.gcDefaultLeaderBoard = leaderboardIdentifer! }
                })
                
            } else {
                // 3. Game center is not enabled on the users device
                self.gcEnabled = false
                print("Local player could not be authenticated!")
                print(error ?? "Error")
            }
        }
    }
    
    @IBAction private func addScorePressed(_ sender: UIButton) {
        sender.showsTouchWhenHighlighted = true
        // Submit score to GC leaderboard
        let bestScoreInt = GKScore(leaderboardIdentifier: LEADERBOARD_ID)
        bestScoreInt.value = Int64(score)
        GKScore.report([bestScoreInt]) { (error) in
            if error != nil {
                print(error!.localizedDescription)
            } else {
                print("Best Score submitted to your Leaderboard!")
            }
        }
    }
    
    @IBAction private func gameCenterPressed(_ sender: UIButton) {
        sender.showsTouchWhenHighlighted = true
        let gcVC = GKGameCenterViewController()
        gcVC.gameCenterDelegate = self
        gcVC.viewState = .leaderboards
        gcVC.leaderboardIdentifier = LEADERBOARD_ID
        present(gcVC, animated: true, completion: nil)
    }
}

extension GameCenterViewController: GKGameCenterControllerDelegate {
    
    func gameCenterViewControllerDidFinish(_ gameCenterViewController: GKGameCenterViewController) {
        gameCenterViewController.dismiss(animated: true, completion: nil)
    }
    
}
