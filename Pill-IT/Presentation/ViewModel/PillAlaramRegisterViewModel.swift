//
//  PillAlaramRegisterViewModel.swift
//  Pill-IT
//
//  Created by JinwooLee on 3/16/24.
//

import Foundation

//TODO: - AlarmDateList는 6개월 주기로 생성한다.

final class PillAlaramRegisterViewModel {
    
    private let repository = RealmRepository()
    
    var selectedPill : Observable<[Pill?]> = Observable([])
    var inputStartDate : Observable<Date> = Observable(Date()) // default로 오늘 날짜 설정
    var inputPeriodType : Observable<PeriodCase?> = Observable(nil)
    var inputDayOfWeekInterval : Observable<[PeriodSpecificDay]?> = Observable(nil) // 특정 요일에서 사용하는 옵저버
    var inputDaysInterval : Observable<(enumCase:PeriodDays, days:Int)?> = Observable(nil) // 간격에서 사용하는 옵저버
    
    var outputAlarmDateList : Observable<[Date]?> = Observable(nil)
    var outputPeriodType : Observable<String> = Observable("")
    var outputSelectedPill : Observable<[Pill]> = Observable([])
    var outputStartDate : Observable<String?> = Observable(nil)
    
    
    var reCalculateAlarmDateList : Observable<PeriodCase?> = Observable(nil)
    
    init() {
        transform()
    }
    
    private func transform() {
        
        selectedPill.bind { [weak self] value in
            guard let self = self else { return }
            value.forEach { item in
                guard let item = item else { return }
                self.outputSelectedPill.value.append(item)
            }
        }
        
        inputStartDate.bind { [weak self] value in
            guard let self = self else { return }
            outputStartDate.value = value.toString(dateFormat: "yyyy년 MM월 dd일")
            
            // 만약 모든 작업 이후에 다시 날짜가 설정될 경우
            guard let currentPeriodType = inputPeriodType.value else { return }
            reCalculateAlarmDateList.value = currentPeriodType
            
            print(outputAlarmDateList.value)
        }
        
        inputPeriodType.bind { [weak self] value in
            guard let self = self else { return }
            
            switch value {
            case .none:
                print("뭐냐")
            case .some(let periodCase):
                switch periodCase {
                case .always:
                    print("always", inputStartDate.value)
                    
                    outputAlarmDateList.value = dateCalculator(startDate: inputStartDate.value,
                                                              byAdding: .day,
                                                              interval: 1)
                    outputPeriodType.value = "매일"
                    
                case .specificDay:
                    print("specificDay")
                    guard let interval = inputDayOfWeekInterval.value else { return }
                    
                    outputAlarmDateList.value = specificDateCalculate(startDate: inputStartDate.value, interval: interval)
                    
                    
                    outputPeriodType.value = interval.count == 7 ? "매일" :interval.map { $0.toString }.joined(separator: ",")
                    
                    print(outputPeriodType.value)
                    
                case .period:
                    print("period")
                    
                    guard let interval = inputDaysInterval.value else { print("?????실행되냐⭕️");return }
                    outputAlarmDateList.value = dateCalculator(startDate: inputStartDate.value,
                                                              byAdding: interval.enumCase.byAdding,
                                                              interval: interval.days)
                    outputPeriodType.value = interval.enumCase.byAdding == Calendar.Component.day && interval.days == 1 ? "매일" : "\(interval.days)\(interval.enumCase.title)"
                }
            }
        }
        
        reCalculateAlarmDateList.bind { [weak self] value in
            guard let self = self else { return }
            guard let value = value else { return }
            
            inputPeriodType.value = value
        }
    }
    
    private func dateCalculator(startDate : Date,
                                byAdding : Calendar.Component,
                                interval : Int) -> [Date] {
        
        let calendar = Calendar.current
        var datesArray : [Date] = []
        
        if let oneYearLater = calendar.date(byAdding: .year, value: 1, to: startDate) {
            var currentDateToAdd = startDate
            while currentDateToAdd <= oneYearLater {
                datesArray.append(currentDateToAdd)
                currentDateToAdd = calendar.date(byAdding: byAdding, value: interval, to: currentDateToAdd)!
            }
        }
        
        return datesArray
    }
    
    private func specificDateCalculate(startDate : Date, interval : [PeriodSpecificDay]) -> [Date] {
        
        let calendar = Calendar.current
        let targetWeekday : [Int] = interval.map{ return $0.rawValue}
        var datesArray = [Date]()
        if let oneYearLater = calendar.date(byAdding: .year, value: 1, to: startDate) {
            
            var currentDateToAdd = startDate
            while currentDateToAdd <= oneYearLater {
                
                let weekday = calendar.component(.weekday, from: currentDateToAdd)
                if targetWeekday.contains(weekday) {
                    datesArray.append(currentDateToAdd)
                }
                currentDateToAdd = calendar.date(byAdding: .day, value: 1, to: currentDateToAdd)!
            }
        }
        return datesArray
    }
    
    
    
    deinit {
        print(#function, " - ✅ PillAlarmViewModel")
    }
}
