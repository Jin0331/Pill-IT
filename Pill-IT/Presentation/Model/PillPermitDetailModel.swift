//
//  PillPermitDetailModel.swift
//  Pill-IT
//
//  Created by JinwooLee on 3/8/24.
//

import Foundation

// 의약품 품목 허가 정보
struct PillPermitDetail : Decodable {
    let body: PillPermitDetailBody
}

struct PillPermitDetailBody : Decodable {
    let pageNo, totalCount, numOfRows: Int
    let items: [PillPermitDetailItems]
}

// MARK: - Item
struct PillPermitDetailItems: Decodable {
    let itemSeq, chart, barCode, materialName: String
    let insertFile, validTerm, eeDocData, udDocData: String
    let nbDocData, mainItemIngr: String

    enum CodingKeys: String, CodingKey {
        case itemSeq = "ITEM_SEQ"
        case chart = "CHART"
        case barCode = "BAR_CODE"
        case materialName = "MATERIAL_NAME"
        case insertFile = "INSERT_FILE"
        case validTerm = "VALID_TERM"
        case eeDocData = "EE_DOC_DATA"
        case udDocData = "UD_DOC_DATA"
        case nbDocData = "NB_DOC_DATA"
        case mainItemIngr = "MAIN_ITEM_INGR"
    }
}
