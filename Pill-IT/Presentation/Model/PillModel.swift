//
//  PillModel.swift
//  Pill-IT
//
//  Created by JinwooLee on 3/7/24.
//

import Foundation

struct PermitHeader : Decodable {
    let body: PillPermit
}

// 의약품 품목 허가 정보
struct PillPermit: Decodable {
    let pageNo, totalCount, numOfRows: Int
    let items: [PillPermitItems]
}

// MARK: - Permit
struct PillPermitItems : Decodable {
    let itemSeq, itemName, entpName: String
    let entpNo, itemPermitDate, spcltyPblc, prductType: String
    let itemIngrName, bigPrdtImgURL, permitKindCode : String

    enum CodingKeys: String, CodingKey {
        case itemSeq = "ITEM_SEQ"
        case itemName = "ITEM_NAME"
        case entpName = "ENTP_NAME"
        case entpNo = "ENTP_NO"
        case itemPermitDate = "ITEM_PERMIT_DATE"
        case spcltyPblc = "SPCLTY_PBLC"
        case prductType = "PRDUCT_TYPE"
        case itemIngrName = "ITEM_INGR_NAME"
        case bigPrdtImgURL = "BIG_PRDT_IMG_URL"
        case permitKindCode = "PERMIT_KIND_CODE"
    }
    
    init(from decoder: any Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.itemSeq = try container.decode(String.self, forKey: .itemSeq)
        self.itemName = try container.decode(String.self, forKey: .itemName)
        self.entpName = try container.decode(String.self, forKey: .entpName)
        self.entpNo = try container.decode(String.self, forKey: .entpNo)
        self.itemPermitDate = try container.decode(String.self, forKey: .itemPermitDate)
        self.spcltyPblc = try container.decode(String.self, forKey: .spcltyPblc)
        self.prductType = try container.decode(String.self, forKey: .prductType)
        self.itemIngrName = try container.decode(String.self, forKey: .itemIngrName)
        self.bigPrdtImgURL = try container.decode(String.self, forKey: .bigPrdtImgURL)
        self.permitKindCode = try container.decode(String.self, forKey: .permitKindCode)
    }
}

