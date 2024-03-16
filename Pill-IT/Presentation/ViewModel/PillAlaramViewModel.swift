//
//  PillAlaramViewModel.swift
//  Pill-IT
//
//  Created by JinwooLee on 3/16/24.
//

import Foundation

class PillAlaramViewModel {
    
    private let repository = RealmRepository()
    
    var selectedPill : Observable< [Pill?]> = Observable([])
    var outputSelectedPill : Observable<[Pill]> = Observable([])
    
    init() {
        transform()
    }
    
    private func transform() {
        
        selectedPill.bind { [weak self] value in
            guard let self = self else { return }
            value.forEach { item in
                guard let item = item else { return }
                self.outputSelectedPill.value.append(item)
            }
        }
        
    }
}
