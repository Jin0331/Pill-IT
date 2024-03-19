//
//  PillNotificationView.swift
//  Pill-IT
//
//  Created by JinwooLee on 3/19/24.
//

import UIKit
import SnapKit
import Then
import FSCalendar

class PillNotificationView: BaseView {
    
    let dayOfWeek = UILabel().then {
        $0.text = "수요일"
        $0.textColor = DesignSystem.colorSet.black
        $0.font = .systemFont(ofSize: 40, weight: .heavy)
    }
    
    let day = UILabel().then {
        $0.text = "3월 19일"
        $0.textColor = DesignSystem.colorSet.black
        $0.font = .systemFont(ofSize: 27, weight: .heavy)
    }
    
    let calendar = FSCalendar(frame: .zero).then {
        $0.scope = .week // 주간 달력 설정
        $0.calendarHeaderView.isHidden = true
        $0.headerHeight = 6.0 // this makes some extra spacing, but you can try 0 or 1
        
        // 요일 설정
        $0.appearance.weekdayFont = .systemFont(ofSize: 15, weight: .heavy)
        $0.appearance.weekdayTextColor = DesignSystem.colorSet.gray
        $0.locale = Locale(identifier: "ko_KR") // 요일 설정 us면 Mon, ko_KR 이면 월,화...
        $0.firstWeekday = 2 // 기본 설정은 일요일(일~토)이 시작이나, 2로 설정하면 월요일부터 시작합니다(월~일
        
        // 일수 설정
        $0.appearance.titleFont = .systemFont(ofSize: 23, weight: .heavy) // 일(1,2,3...) 폰트 설정
        $0.appearance.titleDefaultColor = DesignSystem.colorSet.lightBlack
        $0.appearance.titleSelectionColor = DesignSystem.colorSet.white
        $0.appearance.titleTodayColor = DesignSystem.colorSet.lightBlack
        
        $0.appearance.selectionColor = DesignSystem.colorSet.lightBlack
        $0.appearance.todayColor = .clear
        
//        $0.backgroundColor = .green
    }
    
    override func configureHierarchy() {
        [dayOfWeek, day, calendar].forEach { addSubview($0)}
    }
    
    override func configureLayout() {
        dayOfWeek.snp.makeConstraints { make in
            make.top.leading.equalTo(safeAreaLayoutGuide).inset(20)
            make.height.equalTo(50)
            make.width.equalTo(150)
        }
        
        day.snp.makeConstraints { make in
            make.top.equalTo(dayOfWeek.snp.bottom).offset(5)
            make.leading.equalTo(dayOfWeek)
            make.size.equalTo(dayOfWeek)
        }
        
        calendar.snp.makeConstraints { make in
            make.top.equalTo(day.snp.bottom).offset(10)
            make.horizontalEdges.equalToSuperview()
            make.height.equalTo(200)
        }
        
    }
}
