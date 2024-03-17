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

enum PeriodSpecificDay : Int {
    case sun
    case mon
    case tue
    case wed
    case thu
    case fri
    case sat
}
