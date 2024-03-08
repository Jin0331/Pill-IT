//
//  RegisterPill.swift
//  Pill-IT
//
//  Created by JinwooLee on 3/7/24.
//

import UIKit

class RegisterPillViewController : UIViewController {
    
    override func viewDidLoad() {

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
        
        // 의약품 허가 상세 정보
        PillAPIManager.shared.callRequest(type: PillPermitDetail.self, api: .permitSpecific(itemSeq: "200108399")) { response, error in
            if let error {
                print("에러")
            } else {
                guard let response = response else { return }
                dump(response.body)
            }
        }
        
        
    }
    
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
    
}
