//
//  RegisterPill.swift
//  Pill-IT
//
//  Created by JinwooLee on 3/7/24.
//

import UIKit
import CoreXLSX

class RegisterPillViewController : UIViewController {
    
    var MetaData : Meta = []
    
    override func viewDidLoad() {

        FileDownloadManager.shared.downloadFile(type: .OpenData_ItemPermit) { result in
            switch result {
            case .success(let savedURL):
                print("File downloaded and saved at: \(savedURL)")
                guard let file = XLSXFile(filepath: savedURL.path) else {
                    fatalError("XLSX file at \(savedURL.path) is corrupted or does not exist")
                }
                
                self.MetaData = self.getXLSX2Josn(filepath: savedURL.path)
                
                print(self.MetaData.count)
                
                
            case .failure(let error):
                print("Error downloading file: \(error)")
            }
            
        }
    }
    
    
    func getXLSX2Josn(filepath : String) -> Meta {
        
        var resultMetaData : Meta = []
        
        guard let file = XLSXFile(filepath: filepath) else {
            fatalError("XLSX file at \(filepath) is corrupted or does not exist")
        }
        
        do {
            let wbk = try file.parseWorkbooks().first!
            let path = try file.parseWorksheetPathsAndNames(workbook: wbk).first!.path
            let worksheet = try file.parseWorksheet(at: path)
            
            if let totalRowCount = worksheet.data?.rows.count, let sharedStrings = try file.parseSharedStrings() {
                
                print(totalRowCount)
                
                (2...totalRowCount).forEach { index in
                    let columnCStrings = worksheet.cells(atRows: [UInt(index)]).compactMap() { $0.stringValue(sharedStrings) }
                    
                    resultMetaData.append(MetaList(
                        itemSeq: Int(columnCStrings[colRef.itemSeq.rawValue])!,
                        itemName: columnCStrings[colRef.itemName.rawValue],
                        entpName: columnCStrings[colRef.entpName.rawValue],
                        etcOtcCode: columnCStrings[colRef.etcOtcCode.rawValue]))
                }
            }
        } catch {
            print(error)
        }
        
        return resultMetaData
    }
    
}
