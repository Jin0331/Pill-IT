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
    
    case permitSpecific(itemSeq : String)
    case grainInfo(itemSeq : String)
    
    var endPoint : URL {
        switch self {
        case .permitSpecific:
            return URL(string: PillAPI.baseURL + PillAPI.basePermitURL + "getDrugPrdtPrmsnDtlInq03")!
        case .grainInfo:
            return URL(string: PillAPI.baseURL + "MdcinGrnIdntfcInfoService01")!
        }
    }
    
    var parameter : Parameters {
        switch self {
        case .permitSpecific(let itemSeq):
            return ["serviceKey": API.OpenAPIKey, "item_seq": itemSeq]
        case .grainInfo:
            return ["serviceKey": API.OpenAPIKey]
        }
    }
    
}
