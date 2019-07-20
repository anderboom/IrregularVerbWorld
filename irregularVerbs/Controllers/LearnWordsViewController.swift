//
//  LearnWordsViewController.swift
//  irregularVerbs
//
//  Created by Admin on 5/22/19.
//  Copyright © 2019 RK. All rights reserved.
//

import UIKit

class LearnWordsViewController: UIViewController {

    @IBOutlet private weak var searchBar: UISearchBar!
    @IBOutlet private weak var tableView: UITableView!
    @IBOutlet private weak var clearListButtonOutlet: UIButton!
    @IBOutlet private weak var startButtonOutlet: UIButton!
    private var filteredWords = [Word]()
    private var isSearchActive = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
        searchBar.delegate = self
        tableView.register(ListTableViewCell.nib, forCellReuseIdentifier: ListTableViewCell.identifier)
        startButtonOutlet.layer.cornerRadius = startButtonOutlet.frame.size.height / 5.0
        view.backgroundColor = UIColor(red: 236.0/255.0,
                                       green: 247.0/255.0,
                                       blue: 246.0/255.0,
                                       alpha: 1.0)
    }
    
    
    
    private func alertIfArrayIsEmpty() {
        let alertVC = UIAlertController(title: "Empty list!",
                                        message: "Back to Main list and choose words to learn",
                                        preferredStyle: .alert)
        
        let okAction = UIAlertAction(title: "Ok", style: .default, handler: nil)
        alertVC.addAction(okAction)
        self.present(alertVC, animated: true, completion: nil)
    }
    
    @IBAction private func startPressed(_ sender: UIButton) {
        sender.showsTouchWhenHighlighted = true
        let words = DataManager.instance.learnArray.sorted { (word1, word2) -> Bool in
            word1.id < word2.id
        }
        guard !words.isEmpty else {
            alertIfArrayIsEmpty()
            return
        }
        let currentIndex = 0
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

extension LearnWordsViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return isSearchActive ? filteredWords.count : DataManager.instance.wordsArray.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 80
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: ListTableViewCell.identifier, for: indexPath) as? ListTableViewCell else {fatalError("ListTableViewCell creation failed")}
        cell.imageViewCell.image = #imageLiteral(resourceName: "checked.png")
        cell.backgroundColor = UIColor(red: 236.0/255.0,
                                       green: 247.0/255.0,
                                       blue: 246.0/255.0,
                                       alpha: 0.5)
        let word = isSearchActive ? filteredWords[indexPath.row] : DataManager.instance.wordsArray[indexPath.row]
            if DataManager.instance.learntWordsIdArray.contains(word.id) {
                cell.imageViewCell.image = #imageLiteral(resourceName: "checked on.png")
            } else {
                cell.imageViewCell.image = #imageLiteral(resourceName: "checked.png")
            }
        cell.update(firstForm: word.firstForm, secondForm: word.secondForm, thirdForm: word.thirdForm, translation: word.translation)
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
         guard let cell = tableView.dequeueReusableCell(withIdentifier: ListTableViewCell.identifier, for: indexPath) as? ListTableViewCell else {fatalError("ListTableViewCell creation failed")}
        let word = isSearchActive ? filteredWords[indexPath.row] : DataManager.instance.wordsArray[indexPath.row]
      
            if DataManager.instance.learntWordsIdArray.contains(word.id) {
                DataManager.instance.deleteFromHistory(word)
            } else {
                DataManager.instance.addWord(word)
            }

        if DataManager.instance.learntWordsIdArray.contains(word.id) {
            cell.imageViewCell.image = #imageLiteral(resourceName: "checked on.png")
        } else {
            cell.imageViewCell.image = #imageLiteral(resourceName: "checked.png")
        }
        tableView.reloadData()
        tableView.deselectRow(at: indexPath, animated: true)
    }
//    func tableView(_ tableView: UITableView,
//                   commit editingStyle: UITableViewCell.EditingStyle,
//                   forRowAt indexPath: IndexPath) {
//        guard editingStyle == .delete else { return }
//        let wordForDelete = DataManager.instance.learnArray[indexPath.row]
//        DataManager.instance.deleteFromHistory(wordForDelete)
//        tableView.deleteRows(at: [indexPath], with: .fade)
//    }
//
}

extension LearnWordsViewController: UISearchBarDelegate {
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

extension LearnWordsViewController {
    override open var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        return .portrait
    }
}
