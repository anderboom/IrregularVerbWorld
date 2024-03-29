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
        title = "Listen and learn"
        
        let flagEmoji = DataManager.instance.choosedLanguage?.flagEmoji ?? ""
        let languageTitle = " \(flagEmoji)    "
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: languageTitle, style: .plain,
                                                           target: self, action: #selector(showLanguageScreen))
        
        tableView.delegate = self
        tableView.dataSource = self
        searchBar.delegate = self
        tableView.keyboardDismissMode = .onDrag
        tableView.register(ListTableViewCell.nib, forCellReuseIdentifier: ListTableViewCell.identifier)
        
        exerciseButtonOutlet.layer.cornerRadius = exerciseButtonOutlet.frame.size.height / 5.0
        exerciseButtonOutlet.showsTouchWhenHighlighted = true

        DispatchQueue.main.asyncAfter(deadline: .now() + 5) {
            StoreReviewHelper.checkAndAskForReview()
        }
        
        view.backgroundColor = UIColor(red: 236.0/255.0,
                                       green: 247.0/255.0,
                                       blue: 246.0/255.0,
                                       alpha: 1.0)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.isNavigationBarHidden = false
    }
    
    @objc private func showLanguageScreen() {
        navigationController?.popViewController(animated: true)
    }
}

extension ListViewController: UITableViewDelegate, UITableViewDataSource {
    
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
        cell.imageViewCell.image = #imageLiteral(resourceName: "play-button white.png")
        let word = isSearchActive ? filteredWords[indexPath.row] : DataManager.instance.wordsArray[indexPath.row]
      
        cell.update(firstForm: word.firstForm , secondForm: word.secondForm , thirdForm: word.thirdForm , translation: word.translation)
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let word = isSearchActive ? filteredWords[indexPath.row] : DataManager.instance.wordsArray[indexPath.row]
        DataManager.instance.playSound(word)
        tableView.deselectRow(at: indexPath, animated: true)
    }
}

extension ListViewController: UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        isSearchActive = !searchText.isEmpty
        filteredWords = []
        
        let lowercasedSearchText = searchText.lowercased()
        for item in DataManager.instance.wordsArray {
            let isPartOfFirstForm = item.firstForm.lowercased().contains(lowercasedSearchText)
            let isPartOfTranslation = item.translation.lowercased().contains(lowercasedSearchText)
            if isPartOfFirstForm || isPartOfTranslation {
                filteredWords.append(item)
            }
        }
        tableView.reloadData()
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
