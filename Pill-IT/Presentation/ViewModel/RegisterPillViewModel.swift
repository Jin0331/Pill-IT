//
//  RegisterPillViewModel.swift
//  Pill-IT
//
//  Created by JinwooLee on 3/10/24.
//

import Foundation

class RegisterPillViewModel {
    
    var outputItemNameList : Observable<[String]> = Observable([])
    var outputItemNameSeqList : Observable<[String]> = Observable([])
    var inputItemSeq : Observable<String?> = Observable(nil)
    
    
    var callRequestTrigger : Observable<String?> = Observable(nil)
    
    init() {
        transform()
    }
    
    private func transform() {
        
        callRequestTrigger.bind { value in
            guard let value = value else { return }
            self.callRequestForItemList(value)
        }
        
        inputItemSeq.bind { value in
            guard let value = value else { return }
            
            
        }
        
    }
    
    private func callRequestForItemList(_ searchPill : String) {
        PillAPIManager.shared.callRequest(type: PillPermit.self, api: .permit(itemName: searchPill)) { response, error in
            if let error {
                print(error)
            } else {
                guard let response = response else { return }
                self.outputItemNameList.value = response.body.items.map({ value in
                    return value.itemName
                })
                self.outputItemNameSeqList.value = response.body.items.map({ value in
                    return value.itemSeq
                })

            }
        }
    }
    
    private func callRequestForImage(_ searchPillSeq : String) {
        PillAPIManager.shared.callRequest(type: PillPermit.self, api: .permit(itemName: searchPillSeq)) { response, error in
            if let error {
                print(error)
            } else {
                guard let response = response else { return }
                self.outputItemNameList.value = response.body.items.map({ value in
                    return value.itemName
                })
            }
        }
    }
}


