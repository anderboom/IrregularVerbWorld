//
//  StoreReviewHelper.swift
//  irregularVerbs
//
//  Created by MaksymHusar on 5/24/19.
//  Copyright © 2019 RK. All rights reserved.
//

import Foundation
import StoreKit

struct StoreReviewHelper {
    private static var isShownOnce = false
    private static var appOpeningCounter: Int {
        get { return UserDefaults.standard.integer(forKey: Constants.StorageKeys.appOpenedCountKey) }
        set { UserDefaults.standard.set(newValue, forKey: Constants.StorageKeys.appOpenedCountKey) }
    }
    static func incrementAppOpenedCount() { // called from appdelegate didfinishLaunchingWithOptions:
        appOpeningCounter += 1
    }
    
    static func checkAndAskForReview() {
        guard isShownOnce == false else { return }
        isShownOnce = true
        let counter = appOpeningCounter
        guard counter > 0 else {
            appOpeningCounter = 1
            return
        }

        switch counter {
        case 10, 30:
            StoreReviewHelper().requestReview()
        case _ where counter % 50 == 0:
            StoreReviewHelper().requestReview()
        default:
            print("App run count is : \(counter)")
            break
        }
    }
    
    private func requestReview() {
        SKStoreReviewController.requestReview()
    }
}
