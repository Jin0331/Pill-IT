//
//  RegisterPillViewModel.swift
//  Pill-IT
//
//  Created by JinwooLee on 3/10/24.
//

import Foundation

class RegisterPillViewModel {
    
    var inputItemSeq : Observable<String?> = Observable(nil)
    var inputeItemName : Observable<String?> = Observable(nil)
    
    var outputItemNameList : Observable<[String]?> = Observable(nil)
    var outputItemNameSeqList : Observable<[String]?> = Observable(nil)
    var localImageURL : Observable<String?> = Observable(nil)
    
    var callRequestForItemListTrigger : Observable<String?> = Observable(nil)
    var callcallRequestForImageTrigger : Observable<String?> = Observable(nil)
    
    init() {
        transform()
    }
    
    private func transform() {
        
        callRequestForItemListTrigger.bind { [weak self] value in
            guard let self = self else { return }
            guard let value = value else { return }
            
            self.callRequestForItemList(value)
        }
        
        callcallRequestForImageTrigger.bind { [weak self] value in
            guard let self = self else { return }
            guard let value = value else { return }
            
            self.callRequestForImage(value)
        }
        
        
        inputItemSeq.bind { [weak self] value in
            guard let self = self else { return }
            guard let value = value else { return }
            
            // 흐음???
        }
        
    }
    
    private func callRequestForItemList(_ searchPill : String) {
        PillAPIManager.shared.callRequest(type: PillPermit.self, api: .permit(itemName: searchPill)) { [weak self] response, error in
            guard let self = self else { return }
            
            if let error {
                print("callRequestForItemList - No Search List")
                self.outputItemNameList.value = nil
                self.outputItemNameSeqList.value = nil
                
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
        
        print(searchPillSeq, "callRequestForImage")
        
        PillAPIManager.shared.callRequest(type: PillGrainInfo.self, api: .grainInfo(itemSeq: searchPillSeq)) { response, error in
            if let error {
                print("callRequestForImage - No Search List - 데이터 없음")
                self.localImageURL.value = nil
            } else {
                guard let response = response else { return }
                guard let imageURLKey = response.body.items.first?.itemImage.split(separator: "/").last else { return }
                
                print(imageURLKey, "grainPill - image")
                
                FileDownloadManager.shared.downloadFile(type: .image(id: String(imageURLKey)), pillID: searchPillSeq) { [weak self] value in
                    
                    guard let self = self else { return }
                    
                    switch value {
                    case .success(let result):
                        print(result.path)
                        self.localImageURL.value = result.path
                    case .failure(let error):
                        print(error)
                    }
                    
                }
            }
        }
    }
    
    deinit {
        print(#function, " - RegisterPillViewModel")
    }
}


