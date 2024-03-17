//
//  SharedEnumeration.swift
//  Pill-IT
//
//  Created by JinwooLee on 3/15/24.
//

import Foundation

enum RegisterPillWebSearchViewSection : CaseIterable {
    case main
}

enum PillManagementViewSection : CaseIterable {
    case main
}

enum PillAlarmViewSection : CaseIterable {
    case main
}

enum PeriodViewSection : CaseIterable {
    case main
}

enum PeriodCase : String, CaseIterable {
    case always = "매일"
    case specificDay = "특정 요일"
    case period = "간격"
}

enum PeriodSpecificDay : Int, CaseIterable {
    case mon = 2
    case tue = 3
    case wed = 4
    case thu = 5
    case fri = 6
    case sat = 7
    case sun = 1
    
    var toStringForCollectionView : String {
        switch self {
        case .sun:
            return "🥲 일요일"
        case .mon:
            return "😰 월요일"
        case .tue:
            return "😨 화요일"
        case .wed:
            return "😥 수요일"
        case .thu:
            return "😇 목요일"
        case .fri:
            return "🫠 금요일"
        case .sat:
            return "🤪 토요일"
        }
    }
    
    var toString : String {
        switch self {
        case .sun:
            return "일"
        case .mon:
            return "월"
        case .tue:
            return "화"
        case .wed:
            return "수"
        case .thu:
            return "목"
        case .fri:
            return "금"
        case .sat:
            return "토"
        }
    }
}
