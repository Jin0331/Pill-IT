//
//  PillManagementViewModel.swift
//  Pill-IT
//
//  Created by JinwooLee on 3/14/24.
//

import Foundation
import RealmSwift

final class PillManagementViewModel {
    
    private let repository = RealmRepository()
    
    var outputRegisteredPill : Observable<[Pill]?> = Observable(nil)
    var outputRegisteredPillAlarm : Observable<[PillAlarm]?> = Observable(nil)
    var outputTypeTitleWithStartDate : Observable<String?> = Observable(nil)
    
    var fetchPillItemTrigger : Observable<Void?> = Observable(nil)
    var fetchPillAlarmItemTrigger : Observable<Void?> = Observable(nil)
    var updatePillItemisDeleteTrigger : Observable<Pill?> = Observable(nil)
    var removePillItemRemoveTrigger : Observable<Pill?> = Observable(nil)
    var fetchPillPeriodTitleStartDate : Observable<ObjectId?> = Observable(nil)
    
    init() {
        transform()
        repository.realmLocation() // Realm 위치
    }
    
    private func transform() {
        
        fetchPillItemTrigger.bind { [weak self] _ in
            guard let self = self else { return }
            outputRegisteredPill.value = repository.fetchPillItem()
        }
        
        fetchPillAlarmItemTrigger.bind { [weak self] _ in
            guard let self = self else { return }
            outputRegisteredPillAlarm.value = repository.fetchPillAlarm()
        }
        
        updatePillItemisDeleteTrigger.bind { [weak self] value in
            guard let self = self else { return }
            guard let value = value else { return }
        
            repository.updatePillIsDelete(itemSeq : value.itemSeq)
            
            outputRegisteredPill.value = repository.fetchPillItem()
            outputRegisteredPillAlarm.value = repository.fetchPillAlarm()
        }
        
        fetchPillPeriodTitleStartDate.bind { [weak self] value in
            guard let self = self else { return }
            guard let value = value else { return }
            
            guard let table = repository.fetchPillAlarmSpecific(_id: value) else { return }
            outputTypeTitleWithStartDate.value = table.typeTitleWithStartDate
        }
    }

    deinit {
        print(#function, " - ✅ PillManagementViewModel")
    }
}
