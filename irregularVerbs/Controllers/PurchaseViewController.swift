//
//  PurchaseViewController.swift
//  irregularVerbs
//
//  Created by Admin on 3/21/19.
//  Copyright © 2019 RK. All rights reserved.
//

import UIKit
import StoreKit

class PurchaseViewController: UIViewController {
    
    @IBOutlet private weak var tableView: UITableView!
    @IBOutlet private weak var restoreButtonOutlet: UIButton!
    @IBOutlet private weak var backButtonOutlet: UIButton!
    let iapManager = IAPManager.instance
    let notificationCenter = NotificationCenter.default
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(PurchaseTableViewCell.nib, forCellReuseIdentifier: PurchaseTableViewCell.identifier)
        backButtonOutlet.layer.cornerRadius = backButtonOutlet.frame.size.height / 5.0
        restoreButtonOutlet.layer.cornerRadius = restoreButtonOutlet.frame.size.height / 5.0
        notificationCenter.addObserver(self,
                                       selector: #selector(reload),
                                       name: NSNotification.Name(IAPManager.productNotificationIdentifier),
                                       object: nil)
        notificationCenter.addObserver(self,
                                        selector: #selector(completeNonConsumable),
                                        name: NSNotification.Name(IAPProducts.nonConsumable.rawValue),
                                        object: nil)
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    @IBAction private func restoreButtonPressed(_ sender: Any) {
        iapManager.restoreCompletedTransactions()
    }
    
    private func priceStringFor(product: SKProduct) -> String {
        let numberFormatter = NumberFormatter()
        numberFormatter.numberStyle = .currency
        numberFormatter.locale = product.priceLocale
        
        return numberFormatter.string(from: product.price)!
    }
    
    @objc private func reload() {
        self.tableView.reloadData()
    }
    
    @objc private func completeNonConsumable() {
        IAPManager.instance.isGotNonConsumable = true
        print("got non-consumable")
    }
}

extension PurchaseViewController: UITableViewDelegate, UITableViewDataSource {
   
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return iapManager.products.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
         guard let cell = tableView.dequeueReusableCell(withIdentifier: PurchaseTableViewCell.identifier, for: indexPath) as? PurchaseTableViewCell else {fatalError("PurchaseTableViewCell creation failed")}
        cell.backgroundColor = UIColor(red: 236.0/255.0,
                                       green: 247.0/255.0,
                                       blue: 246.0/255.0,
                                       alpha: 0.5)
        let product = iapManager.products[indexPath.row]
        cell.update(purchaseText: product.localizedTitle + " - " + self.priceStringFor(product: product))
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let identifier = iapManager.products[indexPath.row].productIdentifier
        iapManager.purchase(productWith: identifier)
        tableView.deselectRow(at: indexPath, animated: false)
      
    }
}
