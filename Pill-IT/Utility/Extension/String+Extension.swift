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
    
    static func randomEmoji() -> String {
        let range = [UInt32](0x1F601...0x1F64F)
        let ascii = range[Int(drand48() * (Double(range.count)))]
        let emoji = UnicodeScalar(ascii)?.description
        return emoji!
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
