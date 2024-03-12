//
//  NaverSearchModel.swift
//  Pill-IT
//
//  Created by JinwooLee on 3/12/24.
//

import Foundation


struct NaverSearch: Decodable {
    let items: [NaverSearchItem]
}

// MARK: - Item
struct NaverSearchItem: Decodable, Hashable {
    let title: String
    let link: String
    let thumbnail: String
    let sizeheight, sizewidth: String
}
