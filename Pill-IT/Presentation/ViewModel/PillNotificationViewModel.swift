//
//  PillNotificationViewModel.swift
//  Pill-IT
//
//  Created by JinwooLee on 3/20/24.
//

import Foundation
import RealmSwift

class PillNotificationViewModel {
    
    private let repository = RealmRepository()
    
    var inputCurrentDate : Observable<Date?> = Observable(nil)
    
//    var outputCurrentDateAlarm :
    
    init() {
        transform()
    }
    
    private func transform() {
        inputCurrentDate.bind { [weak self] value in
            guard let self = self else { return }
            guard let value = value else { return }
            
            print(value, "⭕️ ViewModel")
            
            print(repository.fetchPillAlarmDateItem(alaramDate: value))
        }
    }
    
    deinit {
        print(#function, " -  PillNotificationViewModel ✅")
    }
}
