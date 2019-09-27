//
//  DataManager.swift
//  irregularVerbs
//
//  Created by Admin on 1/4/19.
//  Copyright © 2019 RK. All rights reserved.
//

import Foundation
import SwiftyJSON
import AVFoundation

final class DataManager {
    static let instance = DataManager()
    private init() { }
    
    private(set) lazy var wordsArray: [Word] = {
        guard let language = self.choosedLanguage else { return [] }
        return loadWordsFromJson(for: language) ?? []
    }()
    private(set) lazy var learnArray = formWordsToLearn()
    private(set) lazy var skipArray = skipWordsToLearn()
    
    private var audioPlayer: AVAudioPlayer!
    
    func chooseLanguage(_ lng: TranslationLanguage) {
        choosedLanguage = lng
        wordsArray = loadWordsFromJson(for: lng) ?? []
    }
    
    var isTutorialChoosen: Bool {
        get { return UserDefaults.standard.bool(forKey: Constants.StorageKeys.isTutorialChoosen) }
        set { UserDefaults.standard.set(newValue, forKey: Constants.StorageKeys.isTutorialChoosen) }
    }
    
    private(set) var choosedLanguage: TranslationLanguage? {
        get {
            guard let key = UserDefaults.standard.string(forKey: Constants.StorageKeys.choosedTranslationLanguageKey)
                else { return nil }
            return TranslationLanguage(rawValue: key)
        }
        set {
            if let value = newValue?.rawValue {
                UserDefaults.standard.set(value, forKey: Constants.StorageKeys.choosedTranslationLanguageKey)
            } else { UserDefaults.standard.removeObject(forKey: Constants.StorageKeys.choosedTranslationLanguageKey) }
        }
    }
    
    var learntWordsIdArray: [String] {
        get { return UserDefaults.standard.stringArray(forKey: Constants.StorageKeys.learnArrayId) ?? [] }
        set { UserDefaults.standard.set(newValue, forKey: Constants.StorageKeys.learnArrayId) }
    }
    
    var skippedWordsIdArray: [String] {
        get { return UserDefaults.standard.stringArray(forKey: Constants.StorageKeys.skippedtWordsId) ?? [] }
        set { UserDefaults.standard.set(newValue, forKey: Constants.StorageKeys.skippedtWordsId) }
    }
    
    var commonScore: Int {
        get { return UserDefaults.standard.integer(forKey: Constants.StorageKeys.score) }
        set { UserDefaults.standard.set(newValue , forKey: Constants.StorageKeys.score) }
    }
    
    var adCounting: Int = 0
    
    var allOneByOneCurrentWordIndex: Int {
        get { return UserDefaults.standard.integer(forKey: Constants.StorageKeys.allOneByOneCurrentWordIndex) }
        set { UserDefaults.standard.set(newValue, forKey: Constants.StorageKeys.allOneByOneCurrentWordIndex) }
    }
    
    func addWord(_ word: Word) {
        guard !learnArray.contains(word) else { return }
        learnArray.append(word)
        learntWordsIdArray.append(word.id)
    }
    
    func deleteFromHistory(_ word: Word) {
        guard let learntIndex = learnArray.firstIndex(of: word) else {return}
        learnArray.remove(at: learntIndex)
        learntWordsIdArray.remove(at: learntIndex)
    }
    
    func resetWordsToLearn() {
        learnArray.removeAll()
        learntWordsIdArray.removeAll()
    }
    
    func addWordsToSkippedArray(_ word: Word) {
        guard !skippedWordsIdArray.contains(word.id) else { return }
        skipArray.append(word)
        skippedWordsIdArray.append(word.id)
    }
    
    func deleteFromSkippedWordsIdArray(_ word: Word) {
        guard let learntIndex = skipArray.firstIndex(of: word) else {return}
        skipArray.remove(at: learntIndex)
        skippedWordsIdArray.remove(at: learntIndex)
    }
    
    func resetSkippedWords() {
        skipArray.removeAll()
        skippedWordsIdArray.removeAll()
    }
    
    func playVibration() {
        AudioServicesPlaySystemSound(1351)
    }
    
    func playSound(_ word: Word) {
        let sound = URL(fileURLWithPath: Bundle.main.path(forResource: word.voice, ofType: "mp3", inDirectory: "voice") ?? "")
        do {
            audioPlayer = try AVAudioPlayer(contentsOf: sound)
            audioPlayer.play()
        } catch {
            debugPrint("error:\(error)")
        }
    }

    // MARK: - Private methods
    private func formWordsToLearn() -> [Word] {
        var learnArray: [Word] = []
        for word in wordsArray {
            for id in learntWordsIdArray {
                if word.id == id {
                    learnArray.append(word)
                    break
                }
            }
            if learntWordsIdArray.count == learnArray.count {
                break
            }
        }
        return learnArray
    }
    
    private func skipWordsToLearn() -> [Word] {
        var skipArray: [Word] = []
        for word in wordsArray {
            for id in skippedWordsIdArray {
                if word.id == id {
                    skipArray.append(word)
                    break
                }
            }
            if skippedWordsIdArray.count == skipArray.count {
                break
            }
        }
        return skipArray
    }
    
    private func loadWordsFromJson(for language: TranslationLanguage) -> [Word]? {
        guard let url = Bundle.main.url(forResource: language.jsonName, withExtension: "json") else { return nil }
        do {
            let data = try Data(contentsOf: url)
            let decoder = JSONDecoder()
            let jsonData = try decoder.decode(AllWords.self, from: data)
            return jsonData.words.sorted(by: { (word1, word2) -> Bool in
                word1.firstForm < word2.firstForm
            })
        } catch {
            debugPrint("error:\(error)")
            return nil
        }
    }
}
