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
        return loadChoosedLanguageWordsFromJson() ?? []
    }()
    lazy var learnArray = addWordToLearn()
    private var audioPlayer = AVAudioPlayer()
    private var learntIndex = 0
    
    func chooseLanguage(_ lng: TranslationLanguage) {
        choosedLanguage = lng
        wordsArray = loadChoosedLanguageWordsFromJson() ?? []
    }
    
    var isTutorialChoosen: Bool {
        get {
            return UserDefaults.standard.bool(forKey: Constants.isTutorialChoosen)
        }
        set {
            UserDefaults.standard.set(newValue, forKey: Constants.isTutorialChoosen)
        }
    }
    
    private(set) var choosedLanguage: TranslationLanguage? {
        get {
            guard let key = UserDefaults.standard.string(forKey: Constants.choosedTranslationLanguageKey) else { return nil }
            return TranslationLanguage(rawValue: key)
        }
        set {
            if let value = newValue?.rawValue {
                UserDefaults.standard.set(value, forKey: Constants.choosedTranslationLanguageKey)
            } else {
                UserDefaults.standard.removeObject(forKey: Constants.choosedTranslationLanguageKey)
            }
        }
    }
    
    var learntWordsIdArray: [String] {
        get {
            return UserDefaults.standard.stringArray(forKey: Constants.learnArrayId) ?? []
        }
        set {
            UserDefaults.standard.set(newValue, forKey: Constants.learnArrayId)
        }
    }
    
    var progressArray: [String] {
        get {
            return UserDefaults.standard.stringArray(forKey: Constants.progress) ?? []
        }
        set {
            UserDefaults.standard.set(newValue , forKey: Constants.progress)
        }
    }
    
    var adCounting: Int = 0
    
    var indexValue: Int {
        get {
            return UserDefaults.standard.integer(forKey: Constants.index)
        }
        set {
            UserDefaults.standard.set(newValue , forKey: Constants.index)
        }
    }
    
    var learntWordIds: [String] {
        get {
            return UserDefaults.standard.array(forKey: Constants.learntWordsDictionary) as? [String] ?? ["0"]
        }
        set {
            UserDefaults.standard.set(newValue, forKey: Constants.learntWordsDictionary)
        }
    }
    
    private func loadChoosedLanguageWordsFromJson() -> [Word]? {
        guard let jsonName = choosedLanguage?.jsonName else { return nil }
        guard let url = Bundle.main.url(forResource: jsonName, withExtension: "json") else { return nil }
        do {
            let data = try Data(contentsOf: url)
            let decoder = JSONDecoder()
            let jsonData = try decoder.decode(AllWords.self, from: data)
            return jsonData.words
        } catch {
            debugPrint("error:\(error)")
            return nil
        }
    }
    
    func learntWords(_ word: Word){
        if learntWordIds.contains(word.id) {
           
        } else {
            learntWordIds.append(word.id)
        }
    }
    
    func addWordToLearn() -> [Word] {
        var learnArray: [Word] = []
        for i in learntWordsIdArray {
            for word in wordsArray {
                if word.id == i {
                    learnArray.append(word)
                    break
                }
            }
        }
        return learnArray
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
    
    func clearHistory() {
        learnArray = []
        learntWordsIdArray = []
        learntWordIds = []
    }
    
    func playSound(_ word: Word) {
        let sound = URL(fileURLWithPath: Bundle.main.path(forResource: word.voice, ofType: "mp3" , inDirectory: "voice") ?? "" )
        do {
            audioPlayer = try AVAudioPlayer(contentsOf: sound)
            audioPlayer.play()
        } catch {
            debugPrint("error:\(error)")
        }
    }
    
    func progressCount(_ word:Word) {
        guard !progressArray.contains(word.id) else { return }
        progressArray.append(word.id)
    }
    
    func clearProgress() {
        progressArray = []
        learnArray = []
        learntWordIds = []
        learntWordsIdArray = []
        indexValue = 0
        adCounting = 0
    }
}
