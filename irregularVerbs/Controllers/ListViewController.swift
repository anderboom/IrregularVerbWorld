//
//  ListViewController.swift
//  irregularVerbs
//
//  Created by Admin on 1/3/19.
//  Copyright © 2019 RK. All rights reserved.
//

import UIKit

class ListViewController: UIViewController {
    @IBOutlet private weak var searchBar: UISearchBar!
    @IBOutlet private weak var tableView: UITableView!
    @IBOutlet private weak var exerciseButtonOutlet: UIButton!
    private var filteredWords = [Word]()
    private var isSearchActive = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.isNavigationBarHidden = false
        tableView.delegate = self
        tableView.dataSource = self
        searchBar.delegate = self
        tableView.keyboardDismissMode = .onDrag
        tableView.register(ListTableViewCell.nib, forCellReuseIdentifier: ListTableViewCell.identifier)
        exerciseButtonOutlet.layer.cornerRadius = exerciseButtonOutlet.frame.size.height / 5.0
        view.backgroundColor = UIColor(red: 236.0/255.0,
                                       green: 247.0/255.0,
                                       blue: 246.0/255.0,
                                       alpha: 1.0)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(false)
        tableView.reloadData()
//        isLearnArrayEmpty()
    }
    
//    private func isLearnArrayEmpty() {
//        if DataManager.instance.learnArray.isEmpty {
//            historyButtonOutlet.alpha = 0.6
//        } else {
//            historyButtonOutlet.alpha = 1.0
//        }
//        tableView.reloadData()
//    }
    
    @IBAction func backToListController(_ segue: UIStoryboardSegue) {
        tableView.reloadData()
    }
}

extension ListViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return isSearchActive ? filteredWords.count : DataManager.instance.wordsArray.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 65
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: ListTableViewCell.identifier, for: indexPath) as? ListTableViewCell else {fatalError("ListTableViewCell creation failed")}
        cell.backgroundColor = UIColor(red: 236.0/255.0,
                                       green: 247.0/255.0,
                                       blue: 246.0/255.0,
                                       alpha: 0.5)
        cell.imageViewCell.image = #imageLiteral(resourceName: "play-button white.png")
        let word = isSearchActive ? filteredWords[indexPath.row] : DataManager.instance.wordsArray[indexPath.row]
      
//        cell.addToHistoryAction = { [weak self, unowned tableView] in
//            if DataManager.instance.learntWordsIdArray.contains(word.id) {
//                DataManager.instance.deleteFromHistory(word)
//                self?.isLearnArrayEmpty()
//            } else {
//                DataManager.instance.addWord(word)
//                self?.isLearnArrayEmpty()
//            }
//            DataManager.instance.learntWords(word)
//            tableView.reloadData()
//        }
//        if DataManager.instance.learntWordsIdArray.contains(word.id) {
//            cell.addLearnButtonOutlet.setImage(UIImage(named: "checked on.png"), for: .normal)
//        } else {
//            cell.addLearnButtonOutlet.setImage(UIImage(named: "checked.png"), for: .normal)
//        }
//        cell.playCurrentWordAction = { [word] in
//            DataManager.instance.playSound(word)
//        }
        cell.update(firstForm: word.firstForm , secondForm: word.secondForm , thirdForm: word.thirdForm , translation: word.translation)
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
          let word = DataManager.instance.wordsArray[indexPath.row]
          DataManager.instance.playSound(word)
       
    }
}

extension ListViewController: UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        isSearchActive = !searchText.isEmpty
        filteredWords = []
        for item in DataManager.instance.wordsArray {
            if item.firstForm.lowercased().contains(searchText.lowercased()) ||
                item.translation.lowercased().contains(searchText.lowercased())
                {
                filteredWords.append(item)
            }
            tableView.reloadData()
        }
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        view.endEditing(true)
    }
}

extension ListViewController {
    override open var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        return .portrait
    }
}
