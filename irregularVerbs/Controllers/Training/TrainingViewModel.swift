//
//  TrainingViewModel.swift
//  irregularVerbs
//
//  Created by MaksymHusar on 5/21/19.
//  Copyright © 2019 RK. All rights reserved.
//

import Foundation
import GameKit

struct TrainingViewModel {
    enum IterateMode {
        case randomly
        case consistently(currentIndex: Int)
    }
    
    private let words: [Word]
    private let saveCurrentIndexChangeAction: ((_ newIndex: Int) -> Void)?
    
    private var iterateMode: IterateMode
    private var currentIndex: Int
    
    var scoreText: String { return String(DataManager.instance.commonScore) }
    var currentWord: Word {
        return words[currentIndex]
    }
    
    init(words: [Word], iterateMode: IterateMode, saveCurrentIndexChangeAction: ((_ newIndex: Int) -> Void)? = nil) {
        self.words = words
        self.iterateMode = iterateMode
        self.saveCurrentIndexChangeAction = saveCurrentIndexChangeAction
        
        switch iterateMode {
        case .randomly:
            self.currentIndex = Int.random(in: 0..<words.count)
        case .consistently(let index):
            self.currentIndex = index
        }
    }
    
    mutating func moveNext() -> (nextWord: Word, isRestartedFromBeggining: Bool) {
        let isRestartedFromBeggining: Bool
        switch iterateMode {
        case .randomly:
            isRestartedFromBeggining = false
            
            var newIndex = -1
            repeat {
                newIndex = Int.random(in: 0..<words.count)
            } while newIndex == self.currentIndex
            self.currentIndex = newIndex
        case .consistently(let currentIndex):
            let isLastItem = currentIndex == words.count - 1
            isRestartedFromBeggining = isLastItem
            let newIndex = isLastItem ? 0 : currentIndex + 1
            iterateMode = .consistently(currentIndex: newIndex)
            self.currentIndex = newIndex
        }
        saveCurrentIndexChangeAction?(self.currentIndex)
        let nextWord = currentWord
        return (nextWord, isRestartedFromBeggining)
    }
    
    func incrementScoreForMode() {
        switch iterateMode {
        case .randomly:
            DataManager.instance.commonScore += 3
        case .consistently:
            DataManager.instance.commonScore += 2
        }
        setScoreToGameCenter()
    }
    
    func decrementScoreForMode() {
        guard DataManager.instance.commonScore > 1 else { return }
        DataManager.instance.commonScore -= 1
    }
    
    // MARK: - Private methods
    private func setScoreToGameCenter() {
        // Submit score to GC leaderboard
        let score = DataManager.instance.commonScore
        let bestScoreInt = GKScore(leaderboardIdentifier: Constants.GameCenter.leaderboardID)
        bestScoreInt.value = Int64(score)
        GKScore.report([bestScoreInt]) {(error) in
            if let error = error {
                print("ERROR: addScoreToGameCenter failed! \(error.localizedDescription)")
            } else {
                print("Best Score submitted to your Leaderboard!")
            }
        }
    }
    
    func selectIncrement() -> Int {
        switch iterateMode {
        case .randomly:
            return 3
        case .consistently:
            return 2
        }
    }
}
