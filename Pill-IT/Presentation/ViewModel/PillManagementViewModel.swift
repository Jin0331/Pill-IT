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

    
    init() {
        transform()
    }
    
    private func transform() {
        
        fetchPillItemTrigger.bind { [weak self] _ in
            guard let self = self else { return }
            outputRegisteredPill.value = repository.fetchPillItem()
        }
    }
    
    deinit {
        print(#function, " - ✅ PillManagementViewModel")
    }
}
