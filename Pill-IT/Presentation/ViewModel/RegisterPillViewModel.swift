//
//  RegisterPillViewModel.swift
//  Pill-IT
//
//  Created by JinwooLee on 3/10/24.
//

import Foundation

// 여기 위치가 맞는것인가?
enum Section : CaseIterable{
    case main
}

class RegisterPillViewModel {
    
    enum Section : CaseIterable{
        case main
    }
    var inputItemSeq : Observable<String?> = Observable(nil)
    var inputeItemName : Observable<String?> = Observable(nil)
    
    var outputItemNameList : Observable<[String]?> = Observable(nil)
    var outputItemNameSeqList : Observable<[String]?> = Observable(nil)
    var outputItemImageWebLink : Observable<[URL]?> = Observable(nil)
    
    var localImageURL : Observable<String?> = Observable(nil)
    
    var callRequestForItemListTrigger : Observable<String?> = Observable(nil)
    var callcallRequestForImageTrigger : Observable<String?> = Observable(nil)
    var callcallRequestForWebTrigger : Observable<String?> = Observable(nil)
    
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
        
        callcallRequestForWebTrigger.bind { [weak self] _ in
            guard let self = self else { return }
            guard let inputItemName = self.inputeItemName.value else { return }
            
            self.callRequestForWeb(inputItemName)
        }
        
        inputItemSeq.bind { _ in

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
        
        PillAPIManager.shared.callRequest(type: PillGrainInfo.self, api: .grainInfo(itemSeq: searchPillSeq)) { [weak self] response, error in
            guard let self = self else { return }
            
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
    
    private func callRequestForWeb(_ searchPill : String) {
        
        print(searchPill, "callRequestForWeb")
        
        PillAPIManager.shared.callRequest(type: NaverSearch.self, api: .searchImage(query: searchPill)) { [weak self] response, error in
            guard let self = self else { return }
            if let error {
                print(error, " - Naver Search API")
            } else {
                guard let response = response else { return }
                
                self.outputItemImageWebLink.value = response.items.compactMap {
                    let url = URL(string:$0.link)
                    return url
                }                
            }
        }
    }
    
    
    deinit {
        print(#function, " - RegisterPillViewModel")
    }
}


