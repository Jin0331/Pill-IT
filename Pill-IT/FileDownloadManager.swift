//
//  FileDownloadManager.swift
//  Pill-IT
//
//  Created by JinwooLee on 3/7/24.
//

import Foundation

final class FileDownloadManager {
    
    static let shared = FileDownloadManager()
    
    private init() { }
    
    enum FileType  {
        
        fileprivate static let xls = "https://nedrug.mfds.go.kr/cmn/xls/down/"
        fileprivate static let image = "https://nedrug.mfds.go.kr/pbp/cmn/itemImageDownload/"
        
        case OpenData_ItemPermit
        case OpenData_ItemPermitDetail
        case OpenData_PotOpenTabletIdntfc
        case image(id : String)
        
        var endPoint : URL {
            switch self {
            case .OpenData_ItemPermit:
                return URL(string: FileDownloadManager.FileType.xls + "OpenData_ItemPermit")!
            case .OpenData_ItemPermitDetail:
                return URL(string: FileDownloadManager.FileType.xls + "OpenData_ItemPermitDetail")!
            case .OpenData_PotOpenTabletIdntfc:
                return URL(string: FileDownloadManager.FileType.xls + "OpenData_PotOpenTabletIdntfc")!
            case .image(id: let id):
                return URL(string : FileDownloadManager.FileType.image + id)!
            }
        }
        
        var endPointExtension : String {
            switch self {
            case .image :
                return ".jpg"
            default :
                return ".xlsx"
            }
        }
        
        var fileLocation : String {
            let documentsDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
            
            switch self {
            default :
                return  URL.init(string: documentsDirectory
                    .appendingPathComponent(self.endPoint.lastPathComponent + self.endPointExtension).absoluteString)!.path
            }
        }
        
    }
    
    func downloadFile(type : FileType, completion: @escaping (Result<URL, Error>) -> Void) {
        let task = URLSession.shared.downloadTask(with: type.endPoint) { (localURL, _, error) in
            if let error = error {
                completion(.failure(error))
                
                return
            }
            
            guard let localURL = localURL else {
                let customError = NSError(domain: "DownloadError", code: 0, userInfo: nil)
                
                completion(.failure(customError))
                return
            }
            
            // Specify the directory where you want to save the file
            let documentsDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
            let destinationURL = documentsDirectory.appendingPathComponent(type.endPoint.lastPathComponent + type.endPointExtension)
            
            do {
                if FileManager.default.fileExists(atPath: destinationURL.path) {
                    try FileManager.default.removeItem(at: destinationURL)
                }
                
                
                try FileManager.default.moveItem(at: localURL, to: destinationURL)
                completion(.success(destinationURL))
            } catch {
                completion(.failure(error))
            }
        }
        
        task.resume()
    }
}
