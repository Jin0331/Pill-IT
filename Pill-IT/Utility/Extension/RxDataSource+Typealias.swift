//
//  RxDataSource+Typealias.swift
//  Pill-IT
//
//  Created by JinwooLee on 7/31/24.
//

import Foundation
import RxDataSources

struct PillListDataSection {
    var items : [Pill]
}

extension PillListDataSection : SectionModelType {
    
    init(original: PillListDataSection, items: [Pill]) {
        self = original
        self.items = items
    }
}

typealias PillListRxDataSource = RxCollectionViewSectionedReloadDataSource<PillListDataSection>
