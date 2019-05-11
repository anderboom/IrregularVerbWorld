//
//  TrainingViewController.swift
//  irregularVerbs
//
//  Created by Admin on 1/7/19.
//  Copyright © 2019 RK. All rights reserved.
//

import UIKit
import GoogleMobileAds
import AVFoundation

class TrainingViewController: UIViewController  {
    
    var interstitial: GADInterstitial!
    @IBOutlet private weak var playButtonOutlet: UIButton!
    @IBOutlet private weak var resetProgressOutlet: UIButton!
    @IBOutlet private weak var progressLabel: UILabel!
    @IBOutlet private weak var totalProgressLabel: UILabel!
    @IBOutlet private weak var light0: UIImageView!
    @IBOutlet private weak var light1: UIImageView!
    @IBOutlet private weak var light2: UIImageView!
    @IBOutlet private weak var light3: UIImageView!
    @IBOutlet private weak var light4: UIImageView!
    @IBOutlet private weak var nextButtonOutlet: UIButton!
    @IBOutlet private weak var soldier: UIImageView!
    @IBOutlet private weak var infinitiveStackView: UIStackView!
    @IBOutlet private weak var simplePastStackView: UIStackView!
    @IBOutlet private weak var pastParticipleStackView: UIStackView!
    @IBOutlet private weak var simplePastStackViewOutlet: UIStackView!
    @IBOutlet private weak var infinitiveStackViewOutlet: UIStackView!
    @IBOutlet private weak var pastParticipleStackViewOutlet: UIStackView!
    @IBOutlet private weak var backButtonOutlet: UIButton!
    @IBOutlet private weak var translationLabel: UILabel!
    var index = 0
    private var charStep = 0
    private var arrayCharStep = 0
    private var repeatedCharsCounter = 0
    private var mistakesCount = 0
    private var isFirstFormFilled = false
    private var isSecondFormFilled = false
    private var isThirdFormFilled = false
    private var charCountedDictionary = [String: Int]()
    private var charForWordCountedDictionary = [String: Int]()
    private let textField: UITextField? = UITextField(frame: CGRect(x: 0, y: 0, width: 20.00, height: 20.00))
    var wordArray: [Word] = []
    private var stackView: UIStackView?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        backButtonOutlet.layer.cornerRadius = backButtonOutlet.frame.size.height / 5.0
        nextButtonOutlet.layer.cornerRadius = nextButtonOutlet.frame.size.height / 5.0
        playButtonOutlet.layer.cornerRadius = playButtonOutlet.frame.size.height / 5.0
        resetProgressOutlet.layer.cornerRadius = resetProgressOutlet.frame.size.height / 5.0
        progressLabel.layer.cornerRadius = 5
        progressLabel.layer.borderColor = UIColor.lightGray.cgColor
        progressLabel.layer.borderWidth = 1
        totalProgressLabel.layer.cornerRadius = 5
        totalProgressLabel.layer.borderColor = UIColor.lightGray.cgColor
        totalProgressLabel.layer.borderWidth = 1
        nextButtonOutlet.isHidden = true
        totalProgressLabel.text = String(DataManager.instance.wordsArray.count)
        progressLabel.text = String(DataManager.instance.progressArray.count)
        interstitial = GADInterstitial(adUnitID: "ca-app-pub-3940256099942544/8691691433")
        let request = GADRequest()
        interstitial.load(request)
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(false)
//        interstitial = createAndLoadInterstitial()
        infinitiveStackViewOutlet.removeAllSubViews()
        pastParticipleStackViewOutlet.removeAllSubViews()
        simplePastStackViewOutlet.removeAllSubViews()
        infinitiveStackView.removeAllSubViews()
        simplePastStackView.removeAllSubViews()
        pastParticipleStackView.removeAllSubViews()
        if wordArray == DataManager.instance.wordsArray {
            checkIndexToSkip()
            fillTestFieldStackViews()
            addButtonsToStackViews()
        }
        if wordArray == DataManager.instance.learnArray {
            resetProgressOutlet.isHidden = true
            fillTestFieldStackViews()
            addButtonsToStackViews()
        }
    }
    
    private func makeTextfield(words: String, stackView: UIStackView)  {
        for (index, value) in words.enumerated() {
            let textField = UITextField(frame: CGRect(x: 0, y: 0, width: 18.00, height: 18.00))
            textField.delegate = self
            textField.backgroundColor = UIColor.white
            textField.text = String(value)
            textField.textColor = .white
            textField.textAlignment = NSTextAlignment.center
            textField.layer.cornerRadius = textField.frame.size.height / 5.0
            textField.font = UIFont.boldSystemFont(ofSize: 17)
            textField.text = textField.text?.uppercased()
            textField.widthAnchor.constraint(equalToConstant: 20).isActive = true
            stackView.insertArrangedSubview(textField, at: index)
        }
    }
    
    private func fillTestFieldStackViews() {
        translationLabel.text = wordArray[index].translation
        let verbsValue = wordArray[index]
        makeTextfield(words: verbsValue.firstForm, stackView: infinitiveStackViewOutlet)
        makeTextfield(words: verbsValue.secondForm, stackView: simplePastStackViewOutlet)
        makeTextfield(words: verbsValue.thirdForm, stackView: pastParticipleStackViewOutlet)
        
    }
    
    private func addLetterByButtonPressed(stackView: UIStackView, char: String, charIndex: Int) {
        let textField = UITextField(frame: CGRect(x: 0, y: 0, width: 18.00, height: 18.00))
        textField.delegate = self
        textField.backgroundColor = UIColor.white
        textField.text = char
        textField.textAlignment = NSTextAlignment.center
        textField.layer.cornerRadius = textField.frame.size.height / 5.0
        textField.textColor = .black
        textField.font = UIFont.boldSystemFont(ofSize: 17)
        textField.text = textField.text?.uppercased()
        textField.widthAnchor.constraint(equalToConstant: 20).isActive = true
        stackView.insertArrangedSubview(textField, at: charIndex)
    }
    
    private func addButtonsToStackViews() {
        let verbsValue = wordArray[index]
        let wordsCharacterArray = verbsValue.firstForm + verbsValue.secondForm + verbsValue.thirdForm
        makeButtons(words: wordsCharacterArray, stackView1: infinitiveStackView, stackView2: simplePastStackView, stackView3: pastParticipleStackView, action: #selector(pressedButtonAction))
    }
    
    private func makeButtons(words: String, stackView1: UIStackView, stackView2: UIStackView,stackView3: UIStackView ,action: Selector)  {
        let uniqWord = words.orderedSet
        for (index, value) in uniqWord.shuffled().enumerated() {
            let button = UIButton(frame: CGRect(x: 0, y: 0, width: 48, height: 48))
            button.backgroundColor = .gray
            button.setTitle(String(value), for: .normal)
            button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 34)
            button.titleLabel?.text = button.titleLabel?.text?.uppercased()
            button.layer.borderWidth = 1.5
            button.layer.borderColor = UIColor.lightGray.cgColor
            button.layer.cornerRadius = 5
            button.widthAnchor.constraint(equalToConstant: 48).isActive = true
            switch index {
            case 0...4: do {
                stackView1.insertArrangedSubview(button, at: index)
                button.addTarget(self, action: action, for: .touchUpInside)
                }
            case 5...9: do {
                stackView2.insertArrangedSubview(button, at: index - 5)
                button.addTarget(self, action: action, for: .touchUpInside)
                }
            case 10...14: do {
                stackView3.insertArrangedSubview(button, at: index - 10)
                button.addTarget(self, action: action, for: .touchUpInside)
                }
            default:
                break
            }
        }
    }
    
    private func makeCharsCountDict(words: String) -> [String: Int]  {
        for i in 0..<words.count {
            let char = String(words[String.Index(utf16Offset: i, in: words)])
            let repeatedValues = words.filter{String($0) == char}.count
            charCountedDictionary[char] = repeatedValues
        }
        return charCountedDictionary
    }
    
    private func countLettersForButtonAlgoritm(sender: UIButton, words: String, dict: [String: Int]) {
        let char = String(words[String.Index(utf16Offset: arrayCharStep, in: words)])
        if arrayCharStep == 0 {
            if var count = charCountedDictionary[char] {
                if sender.titleLabel?.text == char {
                    if count == 1 {
                        sender.isHidden = true
                        charCountedDictionary[char] = nil
                    }
                    if count > 1 {
                        count = count - 1
                        charCountedDictionary[char] = count
                    }
                    charForWordCountedDictionary = charCountedDictionary
                }
            }
        }
        if arrayCharStep > 0 {
            if var count = charForWordCountedDictionary[char] {
                if sender.titleLabel?.text == char {
                    if count == 1 {
                        sender.isHidden = true
                        charForWordCountedDictionary[char] = nil
                    }
                    if count > 1 {
                        count = count - 1
                        charForWordCountedDictionary[char] = count
                    }
                }
            }
        }
        if arrayCharStep == words.count - 1 {
            charCountedDictionary = [:]
            charForWordCountedDictionary = [:]
        }
    }
    
    private func makeAlgoritmForPressedButton(sender: UIButton,
                                              words: String,
                                              dict: [String : Int]) {
        countLettersForButtonAlgoritm(sender: sender, words: words, dict: dict)
        let verbsValue = wordArray[index]
        let firstFormCount = verbsValue.firstForm.count
        let secondFormCount = verbsValue.secondForm.count
        let thirdFormCount = verbsValue.thirdForm.count
        switch arrayCharStep {
        case 0..<firstFormCount : do {
            let currentLetter = String(words[String.Index(utf16Offset: arrayCharStep, in: words)])
            stackView = infinitiveStackViewOutlet
            if sender.titleLabel?.text == currentLetter {
                if let field = stackView?.arrangedSubviews.last {
                    stackView?.removeArrangedSubview(field)
                    field.removeFromSuperview()
                    addLetterByButtonPressed(stackView: stackView ?? infinitiveStackViewOutlet, char: currentLetter, charIndex: charStep)
                }
                arrayCharStep += 1
                charStep += 1
                if charStep == firstFormCount {
                    isFirstFormFilled = true
                    charStep = 0
                }
                break
            } else {
                animateSoldier()
                mistakesCount += 1
                mistakesProcessing()
                break
            }
            }
        case firstFormCount...(firstFormCount + secondFormCount) - 1: do {
            let currentLetter = String(words[String.Index(utf16Offset: arrayCharStep, in: words)])
            stackView = simplePastStackViewOutlet
            
            if sender.titleLabel?.text == currentLetter {
                if let field = stackView?.arrangedSubviews.last {
                    self.stackView?.removeArrangedSubview(field)
                    field.removeFromSuperview()
                    addLetterByButtonPressed(stackView: stackView ?? simplePastStackViewOutlet, char: currentLetter, charIndex: charStep)
                }
                arrayCharStep += 1
                charStep += 1
                if charStep == secondFormCount {
                    isSecondFormFilled = true
                    charStep = 0
                }
                break
            } else {
                animateSoldier()
                mistakesCount += 1
                mistakesProcessing()
                break
            }
            }
        case (firstFormCount + secondFormCount)..<(firstFormCount + secondFormCount + thirdFormCount): do {
            let currentLetter = String(words[String.Index(utf16Offset: arrayCharStep, in: words)])
            stackView = pastParticipleStackViewOutlet
            
            if sender.titleLabel?.text == currentLetter {
                if let field = stackView?.arrangedSubviews.last {
                    stackView?.removeArrangedSubview(field)
                    field.removeFromSuperview()
                    addLetterByButtonPressed(stackView: stackView ?? pastParticipleStackViewOutlet, char: currentLetter, charIndex: charStep)
                }
                arrayCharStep += 1
                charStep += 1
                if charStep == thirdFormCount {
                    isThirdFormFilled = true
                    charStep = 0
                    arrayCharStep = 0
                }
                break
            } else {
                animateSoldier()
                mistakesCount += 1
                mistakesProcessing()
                break
            }
            }
            
        default:
            break
        }
        if isFirstFormFilled, isSecondFormFilled, isThirdFormFilled {
            nextButtonOutlet.isHidden = false
            isFirstFormFilled = false
            isSecondFormFilled = false
            isThirdFormFilled = false
        }
    }
    
    @IBAction func resetProgressPressed(_ sender: Any) {
        DataManager.instance.clearProgress()
        progressLabel.text = "0"
        index = 0
        infinitiveStackViewOutlet.removeAllSubViews()
        pastParticipleStackViewOutlet.removeAllSubViews()
        simplePastStackViewOutlet.removeAllSubViews()
        infinitiveStackView.removeAllSubViews()
        simplePastStackView.removeAllSubViews()
        pastParticipleStackView.removeAllSubViews()
        fillTestFieldStackViews()
        addButtonsToStackViews()
    }
    
    @IBAction func playButtonPressed(_ sender: Any) {
        let verbsValue = wordArray[index]
        DataManager.instance.playSound(verbsValue)
    }
    
    private func animateSoldier() {
        soldier.animationImages = [#imageLiteral(resourceName: "soldier") ,#imageLiteral(resourceName: "soldier on") ,#imageLiteral(resourceName: "soldier")]
        soldier.animationDuration = 1
        soldier.startAnimating()
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
            self.soldier.stopAnimating()
        }
    }
    
    private func switchOnLights() {
        let lightArray = [light0, light1, light2, light3, light4]
        for light in lightArray {
            light?.image = #imageLiteral(resourceName: "lamp on.png")
        }
    }
    
    private func reloadIfMistaken() {
        charStep = 0
        mistakesCount = 0
        arrayCharStep = 0
        infinitiveStackViewOutlet.removeAllSubViews()
        pastParticipleStackViewOutlet.removeAllSubViews()
        simplePastStackViewOutlet.removeAllSubViews()
        infinitiveStackView.removeAllSubViews()
        simplePastStackView.removeAllSubViews()
        pastParticipleStackView.removeAllSubViews()
        addButtonsToStackViews()
        fillTestFieldStackViews()
        switchOnLights()
    }
    
    private func adRun() {
        guard !IAPManager.instance.isGotNonConsumable else { return }
        DataManager.instance.adCounting += 1
        let stepBeforeAd = DataManager.instance.adCounting
            if interstitial.isReady, stepBeforeAd % 2 == 0 {
                interstitial.present(fromRootViewController: self)
                interstitial = createAndLoadInterstitial()
                print("Ad running...")
            }
    }
    
    private func checkIndexToSkip(){
        let learntArray = DataManager.instance.learntWordsIdArray
        for _ in learntArray {
            if learntArray.contains(String(index)), wordArray == DataManager.instance.wordsArray {
                index += 1
            }
            if index == wordArray.count {
                congratulationPopUp()
                index = 0
            }
        }
    }
    
    @IBAction private func nextButtonPressed(_ sender: Any) {
    
        index += 1
        checkIndexToSkip()
        if index == wordArray.count {
            congratulationPopUp()
            index = 0
        }
        let verbsValue = wordArray[index]
        adRun()
        if wordArray == DataManager.instance.wordsArray {
        DataManager.instance.indexValue = index
        }
        mistakesCount = 0
        infinitiveStackViewOutlet.removeAllSubViews()
        pastParticipleStackViewOutlet.removeAllSubViews()
        simplePastStackViewOutlet.removeAllSubViews()
        infinitiveStackView.removeAllSubViews()
        simplePastStackView.removeAllSubViews()
        pastParticipleStackView.removeAllSubViews()
        addButtonsToStackViews()
        fillTestFieldStackViews()
        nextButtonOutlet.isHidden = true
        switchOnLights()
        DataManager.instance.progressCount(verbsValue)
        progressLabel.text = String(DataManager.instance.progressArray.count)
        
    }
    
   
    
    private func mistakesProcessing() {
        var lightArray = [light0, light1, light2, light3, light4]
        lightArray[mistakesCount - 1]?.image = #imageLiteral(resourceName: "lamp.png")
        AudioServicesPlaySystemSound(1351)
        if mistakesCount == 5 {
            mistakesCount = 0
            alertAboutMistake()
            reloadIfMistaken()
        }
    }
    
    private func mistakesCounting() {
        if mistakesCount == 5 {
            mistakesCount = 0
            reloadIfMistaken()
        }
    }
    
    private func alertAboutMistake() {
        let alertVC = UIAlertController(title: "Dear friend :-)",
                                        message: "You've made five mistakes. Try again",
                                        preferredStyle: .alert)
        
        let okAction = UIAlertAction(title: "Ok", style: .default, handler: nil)
        alertVC.addAction(okAction)
        self.present(alertVC, animated: true, completion: nil)
    }
    
    private func congratulationPopUp() {
        let alertVC = UIAlertController(title: "Congratulations!",
                                        message: "You've learnt some basic irregular verbs.",
                                        preferredStyle: .alert)
        
        let okAction = UIAlertAction(title: "Ok", style: .default, handler: nil)
        alertVC.addAction(okAction)
        self.present(alertVC, animated: true, completion: nil)
    }
    
    @objc func pressedButtonAction(sender: UIButton!) {
        sender.showsTouchWhenHighlighted = true
        let verbsValue = wordArray[index]
        let wordsCharacterArray = verbsValue.firstForm + verbsValue.secondForm + verbsValue.thirdForm
        makeAlgoritmForPressedButton(sender: sender,
                                     words: wordsCharacterArray,
                                     dict: makeCharsCountDict(words: wordsCharacterArray))
        mistakesCounting()
        
    }
    
    @IBAction func backButtonPressed(_ sender: Any) {
        if wordArray == DataManager.instance.wordsArray {
            dismiss(animated: true, completion: nil)
        }
        if wordArray == DataManager.instance.learnArray {
            dismiss(animated: true, completion: nil)
        }
    }
}

extension TrainingViewController: UITextFieldDelegate {
    
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        return false
    }
}

extension TrainingViewController {
    override open var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        return .portrait
    }
}

extension TrainingViewController: GADInterstitialDelegate {
    
    func createAndLoadInterstitial() -> GADInterstitial {
        let interstitial = GADInterstitial(adUnitID: "ca-app-pub-3940256099942544/8691691433")
        interstitial.delegate = self
        interstitial.load(GADRequest())
        return interstitial
    }
    
    func interstitialDidDismissScreen(_ ad: GADInterstitial) {
        interstitial = createAndLoadInterstitial()
    }
}
