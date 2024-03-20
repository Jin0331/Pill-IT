//
//  PopUpPillAlarmGroupViewModel.swift
//  Pill-IT
//
//  Created by JinwooLee on 3/20/24.
//

import Foundation

class PopUpPillAlarmGroupViewModel {
    
    var inputCurrentGroupID : Observable<String?> = Observable(nil)
    var inputCurrentDateAlarmPill : Observable<[Pill]?> = Observable(nil)
    
    var outputCurrentGroupID : Observable<String?> = Observable(nil)
    var outputCurrentDateAlarmPill : Observable<[Pill]?> = Observable(nil)
    
    init() {
        transform()
    }
    
    private func transform() {
        
        inputCurrentGroupID.bind {[weak self] value in
            guard let self = self else { return }
            guard let value = value else { return }
            
            outputCurrentGroupID.value = value
        }
        
        inputCurrentDateAlarmPill.bind { [weak self] value in
            guard let self = self else { return }
            guard let value = value else { return }
            
            outputCurrentDateAlarmPill.value = value
        }
    }
    
    deinit {
        print(#function, " -  PillNotificationViewModel ✅")
    }
}
