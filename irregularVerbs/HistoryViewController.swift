//
//  HistoryViewController.swift
//  irregularVerbs
//
//  Created by Admin on 1/5/19.
//  Copyright © 2019 RK. All rights reserved.
//

import UIKit

class HistoryViewController: UIViewController {

    @IBOutlet private weak var searchBar: UISearchBar!
    @IBOutlet private weak var tableView: UITableView!
    @IBOutlet private weak var mainListButtonOutlet: UIButton!
    @IBOutlet private weak var trainingButtonOutlet: UIButton!
    @IBOutlet private weak var clearListButtonOutlet: UIButton!
    private var filteredWords = [Word]()
    private var isSearchActive = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
        searchBar.delegate = self
        tableView.register(ListTableViewCell.nib, forCellReuseIdentifier: ListTableViewCell.identifier)
        trainingButtonOutlet.layer.cornerRadius = trainingButtonOutlet.frame.size.height / 5.0
        mainListButtonOutlet.layer.cornerRadius = mainListButtonOutlet.frame.size.height / 5.0
        clearListButtonOutlet.layer.cornerRadius = clearListButtonOutlet.frame.size.height / 5.0
        view.backgroundColor = UIColor(red: 236.0/255.0,
                                       green: 247.0/255.0,
                                       blue: 246.0/255.0,
                                       alpha: 1.0)
    }
    
    
    @IBAction func trainingPressed(_ sender: Any) {
       
    }
    
    private func alertIfArrayIsAmpty() {
        let alertVC = UIAlertController(title: "Empty list!",
                                        message: "Back to Main list and choose words to learn",
                                        preferredStyle: .alert)
        
        let okAction = UIAlertAction(title: "Ok", style: .default, handler: nil)
        alertVC.addAction(okAction)
        self.present(alertVC, animated: true, completion: nil)
    }
    
    @IBAction func clearListButtonPressed(_ sender: UIButton) {
        DataManager.instance.clearHistory()
        tableView.reloadData()
    }
    
    @IBAction func backToHistoryController(_ segue: UIStoryboardSegue) {
    
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard segue.identifier == "HistoryToTraining" else {return}
        guard let destVC = segue.destination as? TrainingViewController else {return}
        let wordArray = DataManager.instance.learnArray
        if wordArray.isEmpty {
        alertIfArrayIsAmpty()
        }
        destVC.wordArray = wordArray
        destVC.index = 0
    }
}

extension HistoryViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return isSearchActive ? filteredWords.count : DataManager.instance.learnArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: ListTableViewCell.identifier, for: indexPath) as? ListTableViewCell else {fatalError("ListTableViewCell creation failed")}
        cell.selectionStyle = .none
        cell.backgroundColor = UIColor(red: 236.0/255.0,
                                       green: 247.0/255.0,
                                       blue: 246.0/255.0,
                                       alpha: 0.5)
        let word = isSearchActive ? filteredWords[indexPath.row] : DataManager.instance.learnArray[indexPath.row]
        cell.addLearnButtonOutlet.isHidden = true
        cell.update(firstForm: word.firstForm, secondForm: word.secondForm, thirdForm: word.thirdForm, translation: word.translation)
        cell.playCurrentWordAction = { [word] in
            DataManager.instance.playSound(word)
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView,
                   commit editingStyle: UITableViewCell.EditingStyle,
                   forRowAt indexPath: IndexPath) {
        guard editingStyle == .delete else { return }
        let wordForDelete = DataManager.instance.learnArray[indexPath.row]
        DataManager.instance.deleteFromHistory(wordForDelete)
        tableView.deleteRows(at: [indexPath], with: .fade)
    }
    
}

extension HistoryViewController: UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        isSearchActive = !searchText.isEmpty
        filteredWords = []
        for item in DataManager.instance.learnArray {
            if item.firstForm.lowercased().contains(searchText.lowercased()) ||
                item.translation.lowercased().contains(searchText.lowercased()) {
                filteredWords.append(item)
            }
            tableView.reloadData()
        }
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        view.endEditing(true)
    }
}

extension HistoryViewController {
    override open var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        return .portrait
    }
}
