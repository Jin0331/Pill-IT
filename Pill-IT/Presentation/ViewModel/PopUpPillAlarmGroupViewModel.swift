//
//  PopUpPillAlarmGroupViewModel.swift
//  Pill-IT
//
//  Created by JinwooLee on 3/20/24.
//

import Foundation
import RealmSwift

final class PopUpPillAlarmGroupViewModel {
    
    var inputCurrentGroupPK : Observable<ObjectId?> = Observable(nil)
    var inputCurrentDate : Observable<Date?> = Observable(nil)
    var inputCurrentGroupID : Observable<ObjectId?> = Observable(nil)
    var inputCurrentDateAlarmPill : Observable<[Pill]?> = Observable(nil)
    
    var outputCurrentGroupPK : Observable<ObjectId?> = Observable(nil)
    var outputCurrentDate : Observable<Date?> = Observable(nil)
    var outputCurrentGroupID : Observable<ObjectId?> = Observable(nil)
    var outputCurrentDateAlarmPill : Observable<[Pill]?> = Observable(nil)
    
    init() {
        transform()
    }
    
    private func transform() {
        
        inputCurrentGroupPK.bind {[weak self] value in
            guard let self = self else { return }
            guard let value = value else { return }
            
            outputCurrentGroupPK.value = value
        }
        
        inputCurrentDate.bind  {[weak self] value in
                guard let self = self else { return }
                guard let value = value else { return }
                
            outputCurrentDate.value = value
        }
        
        inputCurrentGroupID.bind {[weak self] value in
            guard let self = self else { return }
            guard let value = value else { return }
            
            outputCurrentGroupID.value = value
        }
        
        inputCurrentDateAlarmPill.bind { [weak self] value in
            guard let self = self else { return }
            guard let value = value else { return }
            
            // isDelete가 false 것만
            outputCurrentDateAlarmPill.value = value.filter { $0.isDeleted == false }
        }
    }
    
    deinit {
        print(#function, " -  PillNotificationViewModel ✅")
    }
}
