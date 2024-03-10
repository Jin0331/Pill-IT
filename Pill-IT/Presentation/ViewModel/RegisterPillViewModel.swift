//
//  RegisterPillViewModel.swift
//  Pill-IT
//
//  Created by JinwooLee on 3/10/24.
//

import Foundation

class RegisterPillViewModel {
    
    var outputItemName : Observable<[String]> = Observable([])
    
    var callRequestTrigger : Observable<String?> = Observable(nil)
    
    init() {
        transform()
    }
    
    private func transform() {
        
        callRequestTrigger.bind { value in
            guard let value = value else { return }
            self.callRequest(value)
        }
    }
    
    func callRequest(_ searchPill : String) {
        PillAPIManager.shared.callRequest(type: PillPermit.self, api: .permit(itemName: searchPill)) { response, error in
            if let error {
                print(error)
            } else {
                guard let response = response else { return }
                self.outputItemName.value = response.body.items.map({ value in
                    return value.itemName
                })
            }
        }
    }
}
