//
//  MainMenuViewController.swift
//  irregularVerbs
//
//  Created by Admin on 1/3/19.
//  Copyright © 2019 RK. All rights reserved.
//

import UIKit

class MainMenuViewController: UIViewController {    
    @IBOutlet private weak var chooseLaguageTextField: UITextField!
    @IBOutlet private weak var pickLanguage: UIPickerView!
    @IBOutlet private weak var confirmButtonOutlet: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        confirmButtonOutlet.layer.cornerRadius = confirmButtonOutlet.frame.size.height / 5.0
        let selectedIndex: Int
        if let choosedLanguage = DataManager.instance.choosedLanguage {
            selectedIndex = TranslationLanguage.allCases.firstIndex(of: choosedLanguage) ?? 0
        } else {
            selectedIndex = TranslationLanguage.allCases.firstIndex(of: .ru) ?? 0
        }
        
        pickLanguage.selectRow(selectedIndex, inComponent: 0, animated: false)
        chooseLaguageTextField.text = TranslationLanguage.allCases[selectedIndex].name
        chooseLaguageTextField.isEnabled = false
    }
    
    @IBAction private func confirmButtonPressed(_ sender: UIButton) {
        sender.showsTouchWhenHighlighted = true
        let selectedIndex = pickLanguage.selectedRow(inComponent: 0)
        let newLanguage = TranslationLanguage.allCases[selectedIndex]
        DataManager.instance.chooseLanguage(newLanguage)
    }
}

extension MainMenuViewController: UIPickerViewDelegate, UIPickerViewDataSource, UITextFieldDelegate {
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return TranslationLanguage.allCases.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return TranslationLanguage.allCases[row].name
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        self.chooseLaguageTextField.text = TranslationLanguage.allCases[row].name
    }
}

extension MainMenuViewController {
    override open var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        return .portrait
    }
}
