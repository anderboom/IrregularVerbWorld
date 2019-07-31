//
//  TranslationLanguage.swift
//  irregularVerbs
//
//  Created by MaksymHusar on 5/11/19.
//  Copyright © 2019 RK. All rights reserved.
//

import Foundation

enum TranslationLanguage: String, CaseIterable {
    case uk, ru, pl, de, fr, es, it
    
    var jsonName: String {
        return "irregular_\(rawValue)"
    }
    
    var locale: String {
        return self.rawValue
    }
    
    var name: String {
        switch self {
        case .uk: return "Українська"
        case .ru: return "Русский"
        case .pl: return "Polish"
        case .de: return "Deutsch"
        case .fr: return "French"
        case .es: return "Spanish"
        case .it: return "Italian"
        }
    }
    
    var flagEmoji: String {
        switch self {
        case .uk: return "🇺🇦"
        case .ru: return "🇷🇺"
        case .pl: return "🇵🇱"
        case .de: return "🇩🇪"
        case .fr: return "🇫🇷"
        case .es: return "🇪🇸"
        case .it: return "🇮🇹"
        }
    }
}
