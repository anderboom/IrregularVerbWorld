//
//  Word.swift
//  irregularVerbs
//
//  Created by Admin on 1/4/19.
//  Copyright © 2019 RK. All rights reserved.
//

import Foundation
import SwiftyJSON

struct AllWords: Codable {
    let version: Int
    let language: String
    let words: [Word]
    
    enum CodingKeys: String, CodingKey {
        case version
        case language
        case words = "data"
    }
}

struct Word: Codable, Equatable {
    let id: String
    let translation: String
    let firstForm: String
    let secondForm: String
    let thirdForm: String
    let voice: String
    
    enum CodingKeys: String, CodingKey {
        case id = "id"
        case translation = "translation"
        case firstForm = "first_form"
        case secondForm = "second_form"
        case thirdForm = "third_form"
        case voice = "voice"
    }
    
    static func == (lhs: Word, rhs: Word) -> Bool {
        return lhs.translation == rhs.translation &&
               lhs.firstForm == rhs.firstForm &&
               lhs.secondForm == rhs.secondForm &&
               lhs.thirdForm == rhs.thirdForm &&
               lhs.id == rhs.id &&
               lhs.voice == rhs.voice
    }
   
    var propertyListRepresentation : [String:String] {
        return ["id" : id, "translation" : translation, "firstForm" : firstForm, "secondForm" : secondForm,"thirdForm" : thirdForm, "voice" : voice]
    }
}

