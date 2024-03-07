//
//  FileDownloader.swift
//  Pill-IT
//
//  Created by JinwooLee on 3/7/24.
//

import Foundation

final class FileDownloader {
    
    static let shared = FileDownloader()
    
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
                return URL(string: FileDownloader.FileType.xls + "OpenData_ItemPermit")!
            case .OpenData_ItemPermitDetail:
                return URL(string: FileDownloader.FileType.xls + "OpenData_ItemPermitDetail")!
            case .OpenData_PotOpenTabletIdntfc:
                return URL(string: FileDownloader.FileType.xls + "OpenData_PotOpenTabletIdntfc")!
            case .image(id: let id):
                return URL(string : FileDownloader.FileType.image + id)!
            }
        }
        
        var endPointExtension : String {
            switch self {
            case .image(let id):
                return ".jpg"
            default :
                return ".xls"
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
                  try FileManager.default.moveItem(at: localURL, to: destinationURL)
                  completion(.success(destinationURL))
              } catch {
                  completion(.failure(error))
              }
          }
          
          task.resume()
      }
}
