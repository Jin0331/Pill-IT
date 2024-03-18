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
    var inputGroupId : Observable<String?> = Observable(nil)
    var inputAlarmSpecificTimeList : Observable<[(hour:Int, minute:Int)]> = Observable([])
    
    var outputAlarmDateList : Observable<[Date]?> = Observable(nil) // 시간이 지정되지 않은 값(날짜만 있음)
    var outputPeriodType : Observable<String?> = Observable(nil)
    var outputSelectedPill : Observable<[Pill]> = Observable([])
    var outputStartDate : Observable<String?> = Observable(nil)
    var outputVisibleSpecificTimeList : Observable<[Date]> = Observable([]) // Diffable Datasource 용
    var outputAlarmSpecificTimeList : Observable<[Date]> = Observable([]) // 실제 Output이 되는 값(날짜 + 시간)
    
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
        
        // (Int,Int) tupple array가 들어오고, output으로 기존의 Date에 조합되어서 나간다.
        // CollectionView에서 수정될 떄마다, 호출되는 bind
        inputAlarmSpecificTimeList.bind { [weak self] value in
            guard let self = self else { return }
            guard let outputAlarmDateList = outputAlarmDateList.value else { print("❌실행안됨?");return }
            
            var tableDateList : [[Date]] = [[]]
            var dataSrouceDateList : [Date] = []
            let calendar = Calendar.current
            let currentDate = Date()
            
            // Table 용 Date List
            value.forEach { item in
                let dateConvert = outputAlarmDateList.map {
                    if let convertDate = calendar.date(bySettingHour: item.hour, minute: item.minute, second: 0, of: $0) {
                        return convertDate
                    } else {
                        return $0
                    }
                }
                tableDateList.append(dateConvert)
            }
            
            // Diffable DataSource 용 Date List
            value.forEach { item in
                dataSrouceDateList.append(calendar.date(bySettingHour: item.hour, minute: item.minute, second: 0, of: currentDate)!)
            }
            
            outputVisibleSpecificTimeList.value = dataSrouceDateList
            outputAlarmSpecificTimeList.value = tableDateList.flatMap{ $0 }
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
        print(#function, " - ✅ PillAlaramRegisterViewModel")
    }
}
