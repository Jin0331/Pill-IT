//
//  PillAPIManager.swift
//  Pill-IT
//
//  Created by JinwooLee on 3/8/24.
//

import Foundation
import Alamofire

class PillAPIManager {
    
    
    static let shared = PillAPIManager()
    
    private init() { }
    
    func callRequest<T:Decodable>(type : T.Type, api : PillAPI, completionHandler : @escaping (T?, AFError?) -> Void) {
        
        AF.request(api.endPoint,
                   method: PillAPI.method,
                   parameters: api.parameter,
                   encoding: URLEncoding(destination: .queryString))
        .responseDecodable(of: type) { response in
            
            switch response.result {
                
            case .success(let success):
                print(api.endPoint, " - API 조회 성공")
                
                completionHandler(success, nil)
            case .failure(let faiure):
                print(faiure)
                
                completionHandler(nil, faiure)
            }
        }
    }
    
    func callRequestStatus(api : PillAPI, completaionHandler : @escaping (Bool) -> Void) {
        
        AF.request(api.endPoint).validate().responseJSON { response in
            print(response.response!.statusCode)
            if (400...499).contains(response.response!.statusCode) {
                completaionHandler(false)
            } else {
                completaionHandler(true)
            }
        }
    }
}


/*
 
 //        FileDownloadManager.shared.downloadFile(type: .OpenData_ItemPermit) { result in
 //            switch result {
 //            case .success(let savedURL):
 //                print("File downloaded and saved at: \(savedURL)")
 //
 //            case .failure(let error):
 //                print("Error downloading file: \(error)")
 //            }
 //        }
         
         
         // 의약품 허가
 //        PillAPIManager.shared.callRequest(type: PillPermit.self, api: .permit(itemName: "크레오신")) { response, error in
 //            if let error {
 //                print("에러")
 //            } else {
 //                guard let response = response else { return }
 //                dump(response.body.items)
 //            }
 //        }
 //
 //        // 의약품 허가 상세 정보
 //        PillAPIManager.shared.callRequest(type: PillPermitDetail.self, api: .permitSpecific(itemSeq: "200108399")) { response, error in
 //            if let error {
 //                print("에러")
 //            } else {
 //                guard let response = response else { return }
 //                dump(response.body)
 //            }
 //        }
         
         
 //    }
     
 //    Using CoreXLSX
 //    func getXLSX2Josn(filepath : String) -> Meta {
 //
 //        guard let file = XLSXFile(filepath: filepath) else {
 //            fatalError("XLSX file at \(filepath) is corrupted or does not exist")
 //        }
 //
 //        do {
 //            let wbk = try file.parseWorkbooks().first!
 //            let path = try file.parseWorksheetPathsAndNames(workbook: wbk).first!.path
 //            let worksheet = try file.parseWorksheet(at: path)
 //
 //            if let sharedStrings = try file.parseSharedStrings() {
 //                let columnCStrings = worksheet.cells(atColumns: [ColumnReference(colRef.itemSeq.rawValue)!])
 //                .compactMap { $0.stringValue(sharedStrings) }
 //            }
 //
 //        } catch {
 //            print(error)
 //        }
 //
 //        return resultMetaData
 //    }
 */
