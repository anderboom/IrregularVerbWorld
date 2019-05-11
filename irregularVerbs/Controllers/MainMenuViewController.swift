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
    @IBOutlet private weak var tutorialButtonOutlet: UIButton!
    @IBOutlet private weak var disableAdsButtonOutlet: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        confirmButtonOutlet.layer.cornerRadius = confirmButtonOutlet.frame.size.height / 5.0
        tutorialButtonOutlet.layer.cornerRadius = tutorialButtonOutlet.frame.size.height / 5.0
        disableAdsButtonOutlet.layer.cornerRadius = disableAdsButtonOutlet.frame.size.height / 5.0
        let row = UserDefaults.standard.integer(forKey: "pickerViewRow")
        pickLanguage.selectRow(row, inComponent: 0, animated: false)
        chooseLaguageTextField.text = DataManager.instance.list[row]
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(false)

        if DataManager.instance.isLanguageChoosen {
            performSegue(withIdentifier: "ListViewController", sender: nil)
            DataManager.instance.chooseLanguage(DataManager.instance.choosedLanguage)
            DataManager.instance.loadJson()
        }
    }
    
    @IBAction func backToMainMenuController(_ segue: UIStoryboardSegue) {
        DataManager.instance.isLanguageChoosen = false
        DataManager.instance.isFirstTimeEnter = true
    }
    
    @IBAction private func confirmButtonPressed(_ sender: UIButton) {
        sender.showsTouchWhenHighlighted = true
        DataManager.instance.choosedLanguage = chooseLaguageTextField.text ?? "Русский"
        DataManager.instance.chooseLanguage(DataManager.instance.choosedLanguage)
        DataManager.instance.loadJson()
    }
}

extension MainMenuViewController: UIPickerViewDelegate, UIPickerViewDataSource, UITextFieldDelegate {
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return DataManager.instance.list.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        self.view.endEditing(true)
        return DataManager.instance.list[row]
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        self.chooseLaguageTextField.text = DataManager.instance.list[row]
        UserDefaults.standard.set(row, forKey: "pickerViewRow")
        self.pickLanguage.isHidden = false
        
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        if textField == self.chooseLaguageTextField {
            self.pickLanguage.isHidden = false
            textField.endEditing(true)
        }
    }
}

extension MainMenuViewController {
    override open var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        return .portrait
    }
}
