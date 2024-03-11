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
        case image(id : String)
        
        var endPoint : URL {
            switch self {
            case .OpenData_ItemPermit:
                return URL(string: FileDownloadManager.FileType.xls + "OpenData_ItemPermit")!
            case .image(let id):
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
    }
    
    func downloadFile(type : FileType, pillID : String, completion: @escaping (Result<URL, Error>) -> Void) {
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
            
            let fileManager = FileManager.default
            // Specify the directory where you want to save the file
            let documentsDirectory = fileManager.urls(for: .documentDirectory, in: .userDomainMask).first!
            
            let directoryURL = documentsDirectory.appendingPathComponent("image/\(pillID)")
            
            let destinationURL = directoryURL.appendingPathComponent(pillID + type.endPointExtension)
            
            // 폴더 생성
            do {
                try fileManager.createDirectory(at: directoryURL, withIntermediateDirectories: true)
            } catch let error {
                print("Create file error: \(error.localizedDescription)")
            }
            
            // 파일 생성 및 이름 변경
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
