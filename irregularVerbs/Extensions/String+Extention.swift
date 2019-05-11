//
//  String+Extention.swift
//  irregularVerbs
//
//  Created by Admin on 1/21/19.
//  Copyright © 2019 RK. All rights reserved.
//

import Foundation

extension String {
    func substringToLastChar(of char: Character) -> String? {
        guard let pos = self.range(of: String(char))?.lowerBound else { return nil }
        let subString = self[..<pos]
        return String(subString)
    }
    
    func contains(find: String) -> Bool{
        return self.range(of: find) != nil
    }
    
    func containsIgnoringCase(find: String) -> Bool{
        return self.range(of: find, options: .caseInsensitive) != nil
    }
}
