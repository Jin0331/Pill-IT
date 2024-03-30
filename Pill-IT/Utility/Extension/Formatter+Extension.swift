//
//  Formatter+Extension.swift
//  CoinMarket
//
//  Created by JinwooLee on 3/17/24.
//

import Foundation

extension String {
    func toDate(dateFormat format : String) -> Date? { //"yyyy-MM-dd HH:mm:ss Z"
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = format
        dateFormatter.timeZone = TimeZone.autoupdatingCurrent
        dateFormatter.locale = Locale.current
        if let date = dateFormatter.date(from: self) {
            return date
        } else {
            return nil
        }
    }
}

extension Double {
    func toNumber(digit : Int, percentage : Bool) -> String? {
        let numberFormatter: NumberFormatter = NumberFormatter()
        numberFormatter.numberStyle = .decimal
        numberFormatter.maximumFractionDigits = digit
        
        let result: String = numberFormatter.string(for: self)!
        return percentage == true ? "\(result)%" : "₩\(result)"
    }
    
    func toPoint() -> String? {
        return self >= 10 ? self.toNumber(digit: 0, percentage: false) : "₩\(String(format:"%.5f", self))"
    }
    
    
    
}

extension Date {
    
    
    var onlyDate: Date {
        let component = Calendar.current.dateComponents([.year, .month, .day], from: self)
        return Calendar.current.date(from: component) ?? Date()
    }
    
    func setKoLocale() -> Date? {
        let dateFormatter = DateFormatter()
        let convertDate = toStringKST(dateFormat: "yyyy년 MM월 dd일")
        
        return dateFormatter.date(from: convertDate)
    }
    
    func toString( dateFormat format: String) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = format
        dateFormatter.timeZone = TimeZone.autoupdatingCurrent
        dateFormatter.locale = Locale.current
        
        let current = Calendar.current
        
        return current.isDateInToday(self) ? dateFormatter.string(from: self)  + " (오늘)" : dateFormatter.string(from: self)
    }
    
    func toStringTime( dateFormat format: String) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = format
        dateFormatter.timeZone = TimeZone.autoupdatingCurrent
        dateFormatter.locale = Locale.current
        
        return dateFormatter.string(from: self)
    }
    
    func toStringKST( dateFormat format: String ) -> String {
        return self.toString(dateFormat: format)
    }
    
    func toStringUTC(_ timezone: Int ) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "a h:m"
        dateFormatter.timeZone = TimeZone(secondsFromGMT: timezone)
        return dateFormatter.string(from: self)
    }
}

struct DateFormatters {
    static var shortDateFormatter: DateFormatter = {
        let dateFormatter = DateFormatter()
        dateFormatter.timeStyle = .none
        dateFormatter.dateStyle = .short
        dateFormatter.locale = Locale(identifier: "ko")
        return dateFormatter
    }()
    
    static var dateFormatter: DateFormatter = {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "d"
        dateFormatter.locale = Locale(identifier: "ko")
        
        return dateFormatter
    }()
    
    static var dateFullFormatter: DateFormatter = {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yy년 M월 d일"
        dateFormatter.locale = Locale(identifier: "ko")
        
        return dateFormatter
    }()
    
    static var weekdayFormatter: DateFormatter = {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "EEE"
        dateFormatter.locale = Locale(identifier: "ko")
        return dateFormatter
    }()
    
    static var weekdayFullFormatter: DateFormatter = {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "EEEE"
        dateFormatter.locale = Locale(identifier: "ko")
        return dateFormatter
    }()
}

extension Calendar {
    func getDateGap(from: Date, to: Date) -> Int {
        let fromDateOnly = from.onlyDate
        let toDateOnly = to.onlyDate
        return self.dateComponents([.day], from: fromDateOnly, to: toDateOnly).day ?? 0
    }
    
    func hourMinuteInitializer(_ currentDate : Date) -> Date {
        let calendar = Calendar.current
        var dateComponents = calendar.dateComponents([.year, .month, .day, .hour, .minute], from: currentDate)
        dateComponents.hour = 0
        dateComponents.minute = 0
        
        return calendar.date(from: dateComponents)!
    }
    
    func hourMinuteRevise(old : Date, new : Date) -> Date{
        let calendar = Calendar.current
        let pickerDateComponents = calendar.dateComponents([.hour, .minute], from: new)
        let oldDateComponents = calendar.dateComponents([.year, .month, .day], from: old)
        
        var newDateComponents = DateComponents()
        newDateComponents.year = oldDateComponents.year!
        newDateComponents.month = oldDateComponents.month!
        newDateComponents.day = oldDateComponents.day!
        newDateComponents.hour = pickerDateComponents.hour!
        newDateComponents.minute = pickerDateComponents.minute!
        
        return calendar.date(from: newDateComponents)!
    }
}
