//
//  PillAlaramRegisterViewModel.swift
//  Pill-IT
//
//  Created by JinwooLee on 3/16/24.
//

import Foundation
import RealmSwift

//TODO: - AlarmDateList는 6개월 주기로 생성한다.
final class PillAlaramRegisterViewModel {
    
    private let repository = RealmRepository()
    
    var inputRegistedPillAlarm : Observable<PillAlarm?> = Observable(nil) //  등록된 알림 수정용
    
    var inputSelectedPill : Observable<[Pill?]> = Observable([])
    var inputStartDate : Observable<Date> = Observable(Date()) // default로 오늘 날짜 설정
    var inputPeriodType : Observable<PeriodCase?> = Observable(nil)
    var inputDayOfWeekInterval : Observable<[PeriodSpecificDay]?> = Observable(nil) // 특정 요일에서 사용하는 옵저버
    var inputDaysInterval : Observable<(enumCase:PeriodDays, days:Int)?> = Observable(nil) // 간격에서 사용하는 옵저버
    var inputGroupId : Observable<String?> = Observable(nil)
    var inputAlarmSpecificTimeList : Observable<[(hour:Int, minute:Int)]> = Observable([])
    
    var outputGroupId : Observable<String?> = Observable(nil)
    var outputAlarmDateList : Observable<[Date]?> = Observable(nil) // 시간이 지정되지 않은 값(날짜만 있음)
    var outputPeriodType : Observable<String?> = Observable(nil)
    var outputSelectedPill : Observable<[Pill]> = Observable([])
    var outputStartDate : Observable<String?> = Observable(nil)
    var outputVisibleSpecificTimeList : Observable<[Date]> = Observable([]) // Diffable Datasource 용
    var outputAlarmSpecificTimeList : Observable<[Date]> = Observable([]) // 실제 Output이 되는 값(날짜 + 시간)
    
    var reCalculateAlarmDateList : Observable<PeriodCase?> = Observable(nil)
    var createTableTrigger : Observable<Void?> = Observable(nil)
    
    init() {
        transform()
    }
    
    private func transform() {
        
        //MARK: - PillAlarmReviseItemViewController 에서 수정시 사용되는 항목
        inputRegistedPillAlarm.bind { [weak self] value in
            guard let self = self else { return }
            guard let value = value else { return }
            let calendar = Calendar.current
            
            inputSelectedPill.value = Array(value.pillList)
            inputGroupId.value = value.alarmName
            outputPeriodType.value = value.typeTitle
    
            // 시작 날짜 시간 초기화... ㅠㅠ
            inputStartDate.value = Calendar.current.hourMinuteInitializer(value.alarmStartDate)
            
            // 등록된 날짜 가져와서 초기화떄리기
            let alarmDateFetch = repository.fetchPillAlarmDateItem(alarmName: value.alarmName)
            let tempDateList = alarmDateFetch!.map { $0.alarmDate }
            outputAlarmDateList.value = tempDateList.map { return Calendar.current.hourMinuteInitializer($0)}
                
            
            // 등록된 날로부터 inputAlarmSpecificTimeList 도 같이 추출
            outputAlarmDateList.value!.forEach({ value in
                let dateComponent = calendar.dateComponents([.hour, .minute], from: value)
                let tempInterval = (hour:dateComponent.hour!, minute:dateComponent.minute!)
                
                if !self.containsTuple(arr: self.inputAlarmSpecificTimeList.value, tup: tempInterval) {
                    self.inputAlarmSpecificTimeList.value.append(tempInterval)
                }
            })
            
        }
        
        //MARK: - PillAlarm 에서 공통적으로 사용하는 항목
        inputGroupId.bind { [weak self] value in
            guard let self = self else { return }
            guard let value = value else { return }
            
            outputGroupId.value = value
        }
        
        inputSelectedPill.bind { [weak self] value in
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
            guard let value = value else { return }
            
            periodCaclulator(periodCase: value)
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
            
            dataSrouceDateList.sort { (($0).compare($1)) == .orderedAscending } // sort
            outputVisibleSpecificTimeList.value = dataSrouceDateList
            outputAlarmSpecificTimeList.value = tableDateList.flatMap{ $0 }
        }
        
        reCalculateAlarmDateList.bind { [weak self] value in
            guard let self = self else { return }
            guard let value = value else { return }
            
            inputPeriodType.value = value
        }
        
        createTableTrigger.bind {[weak self] value in
            guard let self = self else { return }
            
            pillAlaramRegister()

        }
        
    }
    
    //MARK: - 외부 사용 함수
    func containsTuple(arr: [(Int, Int)], tup:(Int, Int)) -> Bool {
         let (c1, c2) = tup

         for (v1, v2) in arr {
            if v1 == c1 && v2 == c2 {
                return true
            }
         }

        return false
    }
    
    //MARK: - 내부 사용 함수
    private func pillAlaramRegister() {
        
        //TODO: - a
        
        guard let alarmName = inputGroupId.value else { return }
        guard let inputPeriodType = inputPeriodType.value else { return }
        guard let outputPeriodType = outputPeriodType.value else { return }
        
        // 기존에 등록된 Table 사용
        let pillsList = List<Pill>()
        outputSelectedPill.value.forEach { pill in
            pillsList.append(pill)
        }
        
        // AlarmDateList는 새로 Table 생성 후 조회로 등록 이때, alarm name으로 검색함
        outputAlarmSpecificTimeList.value.forEach {
            repository.createPill(PillAlarmDate(alarmName: alarmName, alarmDate: $0))
        }
        
        let alarmDateFetch = repository.fetchPillAlarmDateItem(alarmName: alarmName)
        guard let alarmDateFetch = alarmDateFetch else { return }
        
        let alarmDate = List<PillAlarmDate>()
        alarmDateFetch.forEach { pillAlarmDate in
            alarmDate.append(pillAlarmDate)
        }
        
        let pillAlaram = PillAlarm(alarmName: alarmName, pillList: pillsList, type: inputPeriodType.rawValue, typeTitle: outputPeriodType, alarmStartDate: inputStartDate.value, alarmDate: alarmDate)
        
        repository.createPill(pillAlaram)
    }
    
    
    // 내부 사용
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
    
    private func periodCaclulator(periodCase :(PeriodCase)) {
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
    
    deinit {
        print(#function, " - ✅ PillAlaramRegisterViewModel")
    }
}
