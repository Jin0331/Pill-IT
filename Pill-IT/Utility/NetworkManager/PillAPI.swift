//
//  PillAPI.swift
//  Pill-IT
//
//  Created by JinwooLee on 3/7/24.
//

import Foundation
import Alamofire

enum PillAPI  {
   
    static let baseOpeanAPIURL = "http://apis.data.go.kr/1471000/"
    static let baseNaverSearchImageAPIURL = "https://openapi.naver.com/v1/search/image"
    static let basePermitURL = "DrugPrdtPrmsnInfoService05/"
    static let baseGrainInfoURL = "MdcinGrnIdntfcInfoService01/"
    
    // naver Search API용
    static let header : HTTPHeaders = ["X-Naver-Client-Id" : API.naverClientId,
                                       "X-Naver-Client-Secret": API.naverClientSecret]
    static let method : HTTPMethod = .get
    
    case permit(itemName : String)
    case permitSpecific(itemSeq : String)
    case permitMcpn(itemSeq : String)
    case grainInfo(itemSeq : String)
    case searchImage(query : String)
    
    var endPoint : URL {
        switch self {
        case .permit:
            return URL(string: PillAPI.baseOpeanAPIURL + PillAPI.basePermitURL + "getDrugPrdtPrmsnInq05")!
        case .permitSpecific:
            return URL(string: PillAPI.baseOpeanAPIURL + PillAPI.basePermitURL + "getDrugPrdtPrmsnDtlInq04")!
        case .permitMcpn:
            return URL(string: PillAPI.baseOpeanAPIURL + PillAPI.basePermitURL + "getDrugPrdtMcpnDtlInq04")!
        case .grainInfo:
            return URL(string: PillAPI.baseOpeanAPIURL + PillAPI.baseGrainInfoURL + "getMdcinGrnIdntfcInfoList01")!
        case .searchImage:
            return URL(string: PillAPI.baseNaverSearchImageAPIURL)!
        }
    }
    
    var header : HTTPHeaders {
        switch self {
        case .searchImage :
            return ["X-Naver-Client-Id" : API.naverClientId, "X-Naver-Client-Secret": API.naverClientSecret]
        default :
            return [:]
        }
    }
    
    var parameter : Parameters {
        switch self {
        case .permit(let itemName) :
            return ["serviceKey": API.OpenAPIKeyDecoding, "type":"json", "item_name": itemName]
        case .permitSpecific(let itemSeq), .permitMcpn(let itemSeq), .grainInfo(let itemSeq):
            return ["serviceKey": API.OpenAPIKeyDecoding, "type":"json", "item_seq": itemSeq]
        case .searchImage(let query) :
            return ["query":query, "display":20]
        }
    }
    
}
