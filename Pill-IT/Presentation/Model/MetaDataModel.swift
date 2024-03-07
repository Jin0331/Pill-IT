//
//  MetaDataModel.swift
//  Pill-IT
//
//  Created by JinwooLee on 3/7/24.
//

import Foundation

struct MetaList: Decodable {
    let itemSeq: Int
    let itemName, entpName, etcOtcCode: String
    
    enum CodingKeys: String, CodingKey {
        case itemSeq = "품목일련번호"
        case itemName = "품목명"
        case entpName = "업체명"
        case etcOtcCode = "전문일반구분"
    }
        
    enum excelColumnReference : Int, CaseIterable  {
        case itemSeq = 0
        case itemName = 1
        case entpName = 3
        case etcOtcCode = 8
    }
}

typealias colRef = MetaList.excelColumnReference
typealias Meta = [MetaList]
