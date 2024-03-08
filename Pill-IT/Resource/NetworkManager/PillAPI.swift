//
//  PillAPI.swift
//  Pill-IT
//
//  Created by JinwooLee on 3/7/24.
//

import Foundation
import Alamofire

enum PillAPI : CaseIterable {
    static var allCases: [PillAPI] {
        return [.permitSpecific(itemSeq: ""), .grainInfo(itemSeq: "")]
    }
    
    static let baseURL = "http://apis.data.go.kr/1471000/"
    static let basePermitURL = "DrugPrdtPrmsnInfoService05/"
    static let method : HTTPMethod = .get
    
    case permit(itemName : String)
    case permitSpecific(itemSeq : String)
    case permitMcpn(itemSeq : String)
    case grainInfo(itemSeq : String)
    
    var endPoint : URL {
        switch self {
        case .permit:
            return URL(string: PillAPI.baseURL + PillAPI.basePermitURL + "getDrugPrdtPrmsnInq05")!
        case .permitSpecific:
            return URL(string: PillAPI.baseURL + PillAPI.basePermitURL + "getDrugPrdtPrmsnDtlInq04")!
        case .permitMcpn:
            return URL(string: PillAPI.baseURL + PillAPI.basePermitURL + "getDrugPrdtMcpnDtlInq04")!
        case .grainInfo:
            return URL(string: PillAPI.baseURL + "MdcinGrnIdntfcInfoService01")!
        }
    }
    
    var parameter : Parameters {
        switch self {
        case .permit(let itemName) :
            return ["serviceKey": API.OpenAPIKeyDecoding, "type":"json", "item_name": itemName]
        case .permitSpecific(let itemSeq), .permitMcpn(let itemSeq), .grainInfo(let itemSeq):
            return ["serviceKey": API.OpenAPIKeyDecoding, "type":"json", "item_seq": itemSeq]
        }
    }
    
}
