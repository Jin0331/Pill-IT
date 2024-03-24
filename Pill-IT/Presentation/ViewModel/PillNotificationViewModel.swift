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

    var outputCurrentDateAlarm : Observable<[PillAlarmDate]?> = Observable(nil)

    var updatePillItemisDeleteTrigger : Observable<PillAlarmDate?> = Observable(nil)
    var updatePillItemisDoneTrueTrigger : Observable<ObjectId?> = Observable(nil)
    var updatePillItemisDoneFalseTrigger : Observable<ObjectId?> = Observable(nil)
    
    init() {
        transform()
    }
    
    private func transform() {
        
        inputCurrentDate.bind { [weak self] value in
            guard let self = self else { return }
            guard let value = value else { return }
            
            outputCurrentDateAlarm.value = repository.fetchPillAlarmDateItem(alaramDate: value)
        }
            
        // Date로 넘어옴
        updatePillItemisDeleteTrigger.bind { [weak self] value in
            guard let self = self else { return }
            guard let value = value else { return }
            guard let currentDate = inputCurrentDate.value else { return }
            
            print(value, "❗️ ViewModel")
            
            repository.updatePillAlarmDateDelete(value._id)
            outputCurrentDateAlarm.value = repository.fetchPillAlarmDateItem(alaramDate: currentDate)
        }
        
        updatePillItemisDoneTrueTrigger.bind { [weak self] value in
            guard let self = self else { return }
            guard let value = value else { return }
            
            repository.updatePillAlarmisDoneTrue(value)
        }
        
        updatePillItemisDoneFalseTrigger.bind { [weak self] value in
            guard let self = self else { return }
            guard let value = value else { return }
            
            repository.updatePillAlarmisDoneFalse(value)
        }
    }
    
    deinit {
        print(#function, " -  PillNotificationViewModel ✅")
    }
}
