//
//  PillManagementViewModel.swift
//  Pill-IT
//
//  Created by JinwooLee on 3/14/24.
//

import Foundation

final class PillManagementViewModel {
    
    private let repository = RealmRepository()
    
    var outputRegisteredPill : Observable<[Pill]?> = Observable(nil)
    
    var fetchPillItemTrigger : Observable<Void?> = Observable(nil)
    var updatePillItemisDeleteTrigger : Observable<Pill?> = Observable(nil)
    var removePillItemRemoveTrigger : Observable<Pill?> = Observable(nil)
    
    init() {
        transform()
    }
    
    private func transform() {
        
        fetchPillItemTrigger.bind { [weak self] _ in
            guard let self = self else { return }
            outputRegisteredPill.value = repository.fetchPillItem()
        }
        
        updatePillItemisDeleteTrigger.bind { [weak self] value in
            guard let self = self else { return }
            guard let value = value else { print("nil -",#function); return }
        
            repository.updatePillIsDelete(itemSeq : value.itemSeq)
            outputRegisteredPill.value = repository.fetchPillItem()
        }
        
        removePillItemRemoveTrigger.bind { [weak self] value in
            guard let self = self else { return }
            guard let value = value else { print("nil -",#function); return }
            
            repository.removePillItem(row: value)
        }
        
    }

    deinit {
        print(#function, " - ✅ PillManagementViewModel")
    }
}
