//
//  TranslationLanguage.swift
//  irregularVerbs
//
//  Created by MaksymHusar on 5/11/19.
//  Copyright © 2019 RK. All rights reserved.
//

import Foundation

enum TranslationLanguage: String, CaseIterable {
    case ua, ru, pl, de, fr, sp
    
    var jsonName: String {
        return "irregular_\(rawValue)"
    }
    
    var name: String {
        switch self {
        case .ua: return "Українська"
        case .ru: return "Русский"
        case .pl: return "Polish"
        case .de: return "Deutsch"
        case .fr: return "French"
        case .sp: return "Spanish"
        }
    }
}
