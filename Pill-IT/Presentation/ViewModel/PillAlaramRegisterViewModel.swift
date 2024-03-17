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
    var inputStartDate : Observable<Date> = Observable(Date())
    var inputPeriodType : Observable<PeriodCase?> = Observable(nil)
    var inputAlarmDateList : Observable<[Date]?> = Observable(nil)
    
    var outputSelectedPill : Observable<[Pill]> = Observable([])
    var outputStartDate : Observable<String?> = Observable(nil)
    

    
    
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
                    
                    inputAlarmDateList.value = dateCalculator(startDate: inputStartDate.value,
                                                              byAdding: .day,
                                                              interval: 1)
                case .specificDay:
                    print("specificDay")
                case .period:
                    print("period")
                }
            }
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
    
    private func specificDateCalculate(startDate : Date) -> [Date] {

        let calendar = Calendar.current
        let targetWeekday: Int = 2 //         // (일요일 = 1, 토요일 = 7) -> Enum 정의 필요
        var datesArray = [Date]()
        if let oneYearLater = calendar.date(byAdding: .year, value: 1, to: startDate) {

            var currentDateToAdd = startDate
            while currentDateToAdd <= oneYearLater {

                let weekday = calendar.component(.weekday, from: currentDateToAdd)
                if weekday == targetWeekday {
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
