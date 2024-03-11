//
//  PillGrainInfo.swift
//  Pill-IT
//
//  Created by JinwooLee on 3/11/24.
//

import Foundation

struct PillGrainInfo: Decodable {
    let body: PillGrainInfoBody
}

struct PillGrainInfoBody: Decodable {
    let items: [PillGrainInfoItem]
}

struct PillGrainInfoItem: Decodable {
    let itemSeq, itemName, itemImage : String

    enum CodingKeys: String, CodingKey {
        case itemSeq = "ITEM_SEQ"
        case itemName = "ITEM_NAME"
        case itemImage = "ITEM_IMAGE"
    }
}
