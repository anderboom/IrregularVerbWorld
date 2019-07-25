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
        setupWindow()
        StoreReviewHelper.incrementAppOpenedCount()
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
    
    private func setupWindow() {
        let window = UIWindow(frame: UIScreen.main.bounds)
        
        var controllers: [UIViewController] = [TutorialViewController.instantiateVC()]
        
        if DataManager.instance.isTutorialChoosen {
            controllers.append(MainMenuViewController.instantiateVC())
            
            if DataManager.instance.choosedLanguage != nil {
                controllers.append(ListViewController.instantiateVC())
            }
        }
        
        let navigationVC = UINavigationController(rootViewController: UIViewController())
        navigationVC.isNavigationBarHidden = true
        navigationVC.viewControllers = controllers
        window.rootViewController = navigationVC
        self.window = window
        self.window?.makeKeyAndVisible()
    }
    
    func getLanguageCode() -> String {
        let locale = Locale.current
        guard let languageCode = locale.languageCode else
        { return "ua"}
        return languageCode
    }
}

