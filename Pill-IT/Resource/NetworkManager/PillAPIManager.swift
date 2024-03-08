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
