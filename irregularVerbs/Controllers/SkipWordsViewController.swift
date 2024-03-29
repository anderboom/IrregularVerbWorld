//
//  SkipWordsViewController.swift
//  irregularVerbs
//
//  Created by Admin on 7/25/19.
//  Copyright © 2019 RK. All rights reserved.
//

import UIKit

class SkipWordsViewController: UIViewController {

    @IBOutlet private weak var searchBar: UISearchBar!
    @IBOutlet private weak var tableView: UITableView!
    @IBOutlet private weak var startButtonOutlet: UIButton!
    private var filteredWords = [Word]()
    private var isSearchActive = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Select words to skip"
        tableView.delegate = self
        tableView.dataSource = self
        tableView.keyboardDismissMode = .onDrag
        searchBar.delegate = self
        
        tableView.register(ListTableViewCell.nib, forCellReuseIdentifier: ListTableViewCell.identifier)
        startButtonOutlet.layer.cornerRadius = startButtonOutlet.frame.size.height / 5.0
        view.backgroundColor = UIColor(red: 236.0/255.0,
                                       green: 247.0/255.0,
                                       blue: 246.0/255.0,
                                       alpha: 1.0)
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Reset", style: .plain,
                                                            target: self, action: #selector(uncheckWordsToSkip))
    }
    
    @objc func uncheckWordsToSkip() {
        DataManager.instance.resetSkippedWords()
        tableView.reloadData()
    }
    
    private func alertIfArrayIsEmpty() {
        let alertVC = UIAlertController(title: nil,
                                        message: "Select words to skip",
                                        preferredStyle: .alert)
        
        let okAction = UIAlertAction(title: "Ok", style: .default, handler: nil)
        alertVC.addAction(okAction)
        self.present(alertVC, animated: true, completion: nil)
    }
    
    @IBAction func startPressed(_ sender: UIButton) {
        sender.showsTouchWhenHighlighted = true
        let wordsToSkip = DataManager.instance.skipArray
        guard !wordsToSkip.isEmpty else {
            alertIfArrayIsEmpty()
            return
        }
        
       var words: [Word] = []
       let currentIndex = 0
        
        for word in DataManager.instance.wordsArray {
            if DataManager.instance.skipArray.contains(word) {
                print("skipped word")
            } else if words.count < DataManager.instance.wordsArray.count - 1 {
                words.append(word)
            }
        }
        
        let viewModel = TrainingViewModel(words: words,
                                          iterateMode: .consistently(currentIndex: currentIndex))
        startTraining(with: viewModel)
    }
    
    private func startTraining(with viewModel: TrainingViewModel) {
        let destVC = TrainingViewController.instantiateVC()
        destVC.viewModel = viewModel
        navigationController?.pushViewController(destVC, animated: true)
    }
   
}

extension SkipWordsViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return isSearchActive ? filteredWords.count : DataManager.instance.wordsArray.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 82
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: ListTableViewCell.identifier, for: indexPath) as? ListTableViewCell else {fatalError("ListTableViewCell creation failed")}
        cell.backgroundColor = UIColor(red: 236.0/255.0,
                                       green: 247.0/255.0,
                                       blue: 246.0/255.0,
                                       alpha: 0.5)
        let word = isSearchActive ? filteredWords[indexPath.row] : DataManager.instance.wordsArray[indexPath.row]
        if DataManager.instance.skippedWordsIdArray.contains(word.id) {
            cell.imageViewCell.image = #imageLiteral(resourceName: "skip")
        } else {
            cell.imageViewCell.image = #imageLiteral(resourceName: "skip gray")
        }
        cell.update(firstForm: word.firstForm, secondForm: word.secondForm, thirdForm: word.thirdForm, translation: word.translation)
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: ListTableViewCell.identifier, for: indexPath) as? ListTableViewCell else {fatalError("ListTableViewCell creation failed")}
        let word = isSearchActive ? filteredWords[indexPath.row] : DataManager.instance.wordsArray[indexPath.row]
        
        if DataManager.instance.skippedWordsIdArray.contains(word.id) {
            DataManager.instance.deleteFromSkippedWordsIdArray(word)
        } else {
            DataManager.instance.addWordsToSkippedArray(word)
        }
        
        if DataManager.instance.skippedWordsIdArray.contains(word.id) {
            cell.imageViewCell.image = #imageLiteral(resourceName: "skip")
        } else {
            cell.imageViewCell.image = #imageLiteral(resourceName: "skip gray")
        }
        tableView.reloadData()
        tableView.deselectRow(at: indexPath, animated: true)
    }
}

extension SkipWordsViewController: UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        isSearchActive = !searchText.isEmpty
        filteredWords = []
        for item in DataManager.instance.wordsArray {
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

extension SkipWordsViewController {
    override open var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        return .portrait
    }
}
