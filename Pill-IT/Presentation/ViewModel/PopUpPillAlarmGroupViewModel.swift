//
//  PopUpPillAlarmGroupViewModel.swift
//  Pill-IT
//
//  Created by JinwooLee on 3/20/24.
//

import Foundation
import RealmSwift

class PopUpPillAlarmGroupViewModel {
    
    var inputCurrentGroupPK : Observable<ObjectId?> = Observable(nil)
    var inputCurrentGroupID : Observable<String?> = Observable(nil)
    var inputCurrentDateAlarmPill : Observable<[Pill]?> = Observable(nil)
    
    var outputCurrentGroupPK : Observable<ObjectId?> = Observable(nil)
    var outputCurrentGroupID : Observable<String?> = Observable(nil)
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
