//
//  TrainingViewModel.swift
//  irregularVerbs
//
//  Created by MaksymHusar on 5/21/19.
//  Copyright © 2019 RK. All rights reserved.
//

import Foundation

struct TrainingViewModel {
    enum IterateMode {
        case randomly
        case consistently(currentIndex: Int)
    }
    
    private let words: [Word]
    private let saveCurrentIndexChangeAction: ((_ newIndex: Int) -> Void)?
    
    private var iterateMode: IterateMode
    private var currentIndex: Int
    
    var currentWord: Word {
        return words[currentIndex]
    }
    
    init(words: [Word], iterateMode: IterateMode, saveCurrentIndexChangeAction: ((_ newIndex: Int) -> Void)? = nil) {
        self.words = words
        self.iterateMode = iterateMode
        self.saveCurrentIndexChangeAction = saveCurrentIndexChangeAction
        
        self.currentIndex = TrainingViewModel.calculateCurrentIndex(for: iterateMode, arraySize: words.count)
    }
    
    mutating func moveNext() -> (nextWord: Word, isRestartedFromBeggining: Bool) {
        let isRestartedFromBeggining: Bool
        switch iterateMode {
        case .randomly:
            isRestartedFromBeggining = false
        case .consistently(let currentIndex):
            let isLastItem = currentIndex == words.count - 1
            let newIndex = isLastItem ? 0 : currentIndex + 1
            iterateMode = .consistently(currentIndex: newIndex)
            isRestartedFromBeggining = !isLastItem
        }
        self.currentIndex = TrainingViewModel.calculateCurrentIndex(for: iterateMode, arraySize: words.count)
        saveCurrentIndexChangeAction?(self.currentIndex)
        let nextWord = currentWord
        return (nextWord, isRestartedFromBeggining)
    }
    
    private static func calculateCurrentIndex(for mode: IterateMode, arraySize: Int) -> Int {
        switch mode {
        case .randomly:
            return Int.random(in: 0..<arraySize)
        case .consistently(let currentIndex):
            return currentIndex
        }
    }
}
