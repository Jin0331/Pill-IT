//
//  RegisterPillViewModel.swift
//  Pill-IT
//
//  Created by JinwooLee on 3/10/24.
//

import Foundation

final class RegisterPillViewModel {
    
    private let repository = RealmRepository()
    
    var inputItemSeq : Observable<String?> = Observable(nil)
    var inputItemName : Observable<String?> = Observable(nil)
    var inputEntpName : Observable<String?> = Observable(nil)
    var inputEntpNo : Observable<String?> = Observable(nil)
    var inputPrductType : Observable<String?> = Observable(nil)
    var localImageURL : Observable<String?> = Observable(nil)
    var modifyStatus : Observable<Bool> = Observable(false)
    
    var outputItemEntpNameSeqList : Observable<[(itemSeq:String, itemName:String, entpName:String, entpNo:String, prductType:String)]?> = Observable(nil)
    var outputItemImageWebLink : Observable<[URL]?> = Observable(nil)
    
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
            
            callRequestForItemList(value)
        }
        
        callcallRequestForImageTrigger.bind { [weak self] value in
            guard let self = self else { return }
            guard let value = value else { return }
            
            callRequestForImage(value)
        }
        
        callcallRequestForWebTrigger.bind { [weak self] _ in
            guard let self = self else { return }
            guard let inputItemName = self.inputItemName.value else { return }
            
            callRequestForWeb(inputItemName)
        }
    }
    
    private func callRequestForItemList(_ searchPill : String) {
        PillAPIManager.shared.callRequest(type: PillPermit.self, api: .permit(itemName: searchPill)) { [weak self] response, error in
            guard let self = self else { return }
            
            if let error {
                print("callRequestForItemList - No Search List", error)
                NotificationCenter.default.post(name: Notification.Name("searchError"), object: nil)
                outputItemEntpNameSeqList.value = nil
            } else {
                guard let response = response else { return }
                outputItemEntpNameSeqList.value = response.body.items.map({ value in
                    return (value.itemSeq, value.itemName, value.entpName, value.entpNo, value.prductType)
                })
            }
        }
    }
    
    private func callRequestForImage(_ searchPillSeq : String) {
        
        print(searchPillSeq, "callRequestForImage")
        
        PillAPIManager.shared.callRequest(type: PillGrainInfo.self, api: .grainInfo(itemSeq: searchPillSeq)) { [weak self] response, error in
            guard let self = self else { return }
            
            if let error {
                print("callRequestForImage - No Search List - 데이터 없음", error)
                localImageURL.value = nil
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
                
                outputItemImageWebLink.value = response.items.compactMap {
                    let url = URL(string:$0.link)
                    return url
                }
            }
        }
    }
    
    enum PillRegisterError: Error {
        case duplicate
        case none
    }
    
    func pillRegister(completionHandler : @escaping (Result<Void, PillRegisterError>) -> ()) {
        
        if let itemSeq = inputItemSeq.value, let itemName = inputItemName.value, let entpName = inputEntpName.value, let entpNo = inputEntpNo.value, let prductType = inputPrductType.value ,let image = localImageURL.value {
            
            if isPillExist(itemSeq) && !modifyStatus.value {
                completionHandler(.failure(.duplicate))
            } else {
                
                if modifyStatus.value {
                    repository.updatePillImage(itemSeq: itemSeq.toInt, imagePath: localImageURL.value!)
                } else {
                    repository.createPill(Pill(itemSeq: itemSeq.toInt, itemName: itemName, entpName: entpName, entpNo: entpNo, prductType: prductType, urlPath: image))
                }
                completionHandler(.success(()))
            }
            
        }
    }
    
    func isPillExist(_ itemSeq : String) -> Bool {
        return repository.fetchPillExist(itemSeq: itemSeq.toInt)
    }
    
    func pillDataBindForModify(_ itemSeq : String) {
        // 기존 데이터 삽입
        
        print(#function, itemSeq)
        
        if let currentTable = repository.fetchPillSpecific(itemSeq: itemSeq.toInt) {
            modifyStatus.value = true
            inputItemSeq.value = currentTable.itemSeq.toString
            inputItemName.value = currentTable.itemName
            inputEntpName.value = currentTable.entpName
            inputEntpNo.value = currentTable.entpNo
            inputPrductType.value = currentTable.prductType
            localImageURL.value = currentTable.urlPath
        }
    }
    
    deinit {
        print(#function, " - ✅ RegisterPillViewModel")
    }
}


