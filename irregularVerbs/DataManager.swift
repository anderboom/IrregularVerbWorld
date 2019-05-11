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
    private init() { loadJson() }
    private(set) var list = ["Українська","Русский","Polish","Deutsch","French","Spanish"]
    private(set) var wordsArray: [Word] = []
    lazy var learnArray = addWordToLearn()
    private var audioPlayer = AVAudioPlayer()
    private var choosedJson: String = ""
    private var learntIndex = 0
    
    func chooseLanguage(_ lng: String) {
        if lng == "Deutsch" {
            choosedJson = "irregular_de"
            choosedLanguage = lng
            isLanguageChoosen = true
        }
        if lng == "Русский" {
            choosedJson = "irregular_ru"
            choosedLanguage = lng
            isLanguageChoosen = true
        }
        if lng == "Українська" {
            choosedJson = "irregular_ua"
            choosedLanguage = lng
            isLanguageChoosen = true
        }
        if lng == "Polish" {
            choosedJson = "irregular_pl"
            choosedLanguage = lng
            isLanguageChoosen = true
        }
        if lng == "French" {
            choosedJson = "irregular_fr"
            choosedLanguage = lng
            isLanguageChoosen = true
        }
        if lng == "Spanish" {
            choosedJson = "irregular_sp"
            choosedLanguage = lng
            isLanguageChoosen = true
        }
    }
    
    var isTutorialChoosen: Bool {
        get{
            return UserDefaults.standard.bool(forKey: Constants.isTutorialChoosen)
        } set {
            UserDefaults.standard.set(newValue , forKey: Constants.isTutorialChoosen)
        }
    }
    
    var isFirstTimeEnter: Bool {
        get{
            return UserDefaults.standard.bool(forKey: Constants.firstTimeCounting)
        } set {
            UserDefaults.standard.set(newValue, forKey: Constants.firstTimeCounting)
        }
    }
    
    var isLanguageChoosen: Bool {
        get{
            return UserDefaults.standard.bool(forKey: Constants.isLanguageChoosen)
        } set {
            UserDefaults.standard.set(newValue , forKey: Constants.isLanguageChoosen)
        }
    }
    
    var choosedLanguage: String {
        get {
            return UserDefaults.standard.string(forKey: Constants.language) ?? ""
        } set {
            UserDefaults.standard.set(newValue , forKey: Constants.language)
        }
    }
    
    var learntWordsIdArray: [String] {
        get {
            return UserDefaults.standard.stringArray(forKey: Constants.learnArrayId) ?? []
        } set {
            UserDefaults.standard.set(newValue , forKey: Constants.learnArrayId)
        }
    }
    
    var progressArray: [String] {
        get {
            return UserDefaults.standard.stringArray(forKey: Constants.progress) ?? []
        } set {
            UserDefaults.standard.set(newValue , forKey: Constants.progress)
        }
    }
    
    var adCounting: Int = 0
    
    var indexValue: Int {
        get {
            return UserDefaults.standard.integer(forKey: Constants.index)
        } set {
            UserDefaults.standard.set(newValue , forKey: Constants.index)
        }
    }
    
    var learntWordIds: [String] {
        get {
            return UserDefaults.standard.array(forKey: Constants.learntWordsDictionary) as? [String] ?? ["0"]
        } set {
            UserDefaults.standard.set(newValue, forKey: Constants.learntWordsDictionary)
        }
    }
    
    func loadJson() {
        if let url = Bundle.main.url(forResource: choosedJson, withExtension: "json") {
            do {
                let data = try Data(contentsOf: url)
                let decoder = JSONDecoder()
                let jsonData = try decoder.decode(AllWords.self, from: data)
                self.wordsArray = jsonData.words
            } catch {
                debugPrint("error:\(error)")
            }
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
        if learnArray.contains(word) {
            
        } else {
            learnArray.append(word)
            learntWordsIdArray.append(word.id)
        }
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
        if progressArray.contains(word.id) {
        } else {
            progressArray.append(word.id)
        }
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
