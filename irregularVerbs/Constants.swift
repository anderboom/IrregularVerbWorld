//
//  Constants.swift
//  irregularVerbs
//
//  Created by Admin on 2/3/19.
//  Copyright © 2019 RK. All rights reserved.
//

import Foundation

enum Constants {
    static let index = "index"
    static let progress = "progress"
    static let learnArrayId = "learnArrayId"
    static let language = "language"
    static let isLanguageChoosen = "isLanguageChoosen"
    static let firstTimeCounting = "firstTimeCounting"
    static let learntWordsDictionary = "learntWordsDictionary"
    static let isTutorialChoosen = "isTutorialChoosen"
    static let isGotNonConsumable = "isGotNonConsumable"
    
    enum AdMob {
        static var adUnitID: String {
            #if DEBUG
                return "ca-app-pub-3940256099942544/5135589807" // Test Interstitial Video ID
            #else
                return "ca-app-pub-9857481420620374/5808629919" // Real ID
            #endif
        }
    }
}
