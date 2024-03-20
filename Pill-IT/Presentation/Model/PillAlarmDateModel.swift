//
//  PillAlarmDateModel.swift
//  Pill-IT
//
//  Created by JinwooLee on 3/20/24.
//

import Parchment

struct CalendarItem: PagingItem, Hashable, Comparable {
    let date: Date
    let dateText: String
    let weekdayText: String

    init(date: Date) {
        self.date = date
        dateText = DateFormatters.dateFormatter.string(from: date)
        weekdayText = DateFormatters.weekdayFormatter.string(from: date)
    }

    static func < (lhs: CalendarItem, rhs: CalendarItem) -> Bool {
        return lhs.date < rhs.date
    }
}
