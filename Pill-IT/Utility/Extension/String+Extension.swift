//
//  String+Extension.swift
//  Pill-IT
//
//  Created by JinwooLee on 3/12/24.
//

import Foundation

extension String {
    var isHangul: Bool {
        return "\(self)".range(of: "\\p{Hangul}", options: .regularExpression) != nil
    }
    
    var isLatin: Bool {
        return "\(self)".range(of: "\\p{Latin}", options: .regularExpression) != nil
    }
    
    func regxRemove(regString : String) -> String {
        
        var temp = self
        if let range = temp.range(of: regString) {
            temp.removeSubrange(range.lowerBound...)
        }
        
        return temp
    }
    
    var toInt : Int {
        let nIntVal : Int? = Int(self)
        if let nIntVal {
            return nIntVal
        } else {
            return -999
        }
    }
}

extension Int {
    var toString : String {
        let nStringVal : String? = String(self)
        if let nStringVal {
            return nStringVal
        } else {
            return ""
        }
    }
}
