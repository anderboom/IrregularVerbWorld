//
//  AppDelegate.swift
//  irregularVerbs
//
//  Created by Admin on 1/3/19.
//  Copyright © 2019 RK. All rights reserved.
//

import UIKit
import Siren
import Firebase

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?


    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
       
        Siren.shared.wail()
        FirebaseApp.configure()
        GADMobileAds.sharedInstance().start(completionHandler: nil)
        IAPManager.instance.setupPurchases { success in
            if success {
                print("Can make payment")
                IAPManager.instance.getProducts()
            }
        }
        return true
    }

}

