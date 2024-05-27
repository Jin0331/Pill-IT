//
//  PillAlaramRegisterViewModel.swift
//  Pill-IT
//
//  Created by JinwooLee on 3/16/24.
//

import Foundation
import RealmSwift
import UserNotifications
import RxSwift
import RxCocoa

//TODO: - AlarmDateList는 6개월 주기로 생성한다.
final class PillAlaramRegisterViewModel {
    
    private let repository = RealmRepository()
    private let userNotificationCenter = UNUserNotificationCenter.current()
    
    var inputRegistedPillAlarm : Observable<PillAlarm?> = Observable(nil) //  등록된 알림 수정용
    
    //MARK: - Input
    var inputSelectedPill : Observable<[Pill?]> = Observable([])
    var inputStartDate : Observable<Date> = Observable(Calendar.current.hourMinuteInitializer(Date())) // default로 오늘 날짜 설정
    var inputPeriodType : Observable<PeriodCase?> = Observable(nil)
    var inputDayOfWeekInterval : Observable<[PeriodSpecificDay]?> = Observable(nil) // 특정 요일에서 사용하는 옵저버
    var inputDaysInterval : Observable<(enumCase:PeriodDays, days:Int)?> = Observable(nil) // 간격에서 사용하는 옵저버
    var inputGroupId : Observable<ObjectId?> = Observable(nil)
    var inputAlarmName : Observable<String?> = Observable(nil)
    var inputAlarmSpecificTimeList : Observable<[(hour:Int, minute:Int)]> = Observable([])
    var inputPillAlarmNameExist : Observable<String?> = Observable(nil)
    var inputHasChanged : Observable<Bool> = Observable(false)
    
    //MARK: - Output
    var outputGroupId : Observable<ObjectId?> = Observable(nil)
    var outputAlarmName : Observable<String?> = Observable(nil)
    var outputAlarmDateList : Observable<[Date]?> = Observable(nil) // 시간이 지정되지 않은 값(날짜만 있음)
    var outputPeriodType : Observable<String?> = Observable(nil)
    var outputSelectedPill : Observable<[Pill]> = Observable([])
    var outputStartDate : Observable<String?> = Observable(nil)
    var outputVisibleSpecificTimeList : Observable<[Date]> = Observable([]) // Diffable Datasource 용
    var outputAlarmSpecificTimeList : Observable<[Date]> = Observable([]) // 실제 Output이 되는 값(날짜 + 시간)
    var outputPillAlarmNameExist : Observable<Bool?> = Observable(nil)
    var outputHasChanged : Observable<Bool> = Observable(false)
    
    //MARK: - Trigger
    var reCalculateAAlarmSpecificTimeListTrigger : Observable<[(hour:Int, minute:Int)]?> = Observable(nil)
    var reCalculateAlarmDateList : Observable<PeriodCase?> = Observable(nil)
    var createTableTrigger : Observable<Void?> = Observable(nil)
    var revisePeriodTableTrigger : Observable<Void?> = Observable(nil)
    var reviseAlarmRemoveTrigger : Observable<ObjectId?> = Observable(nil) // 알람 수정화면에서 전체 삭제를 위한 트리거
    var reviseAlarmPopUpTrigger : Observable<ObjectId?> = Observable(nil)
    
    //MARK: - RX Input & Output
    let input = Input()
    let output = Output()
    let disposeBag = DisposeBag()
    
    //MARK: - Rx Input
    struct Input {
        let inputIsCompleted = BehaviorRelay(value: false)
        let inputIsReviseItemCompleted = BehaviorRelay(value: false)
        let inputIsReviseDateCompleted = BehaviorRelay(value: false)
    }
    
    //MARK: - Rx Output
    struct Output {
        let outputAlarmname = PublishSubject<String>()
        let outputAlarmDateList = BehaviorSubject<Bool>(value: false)
        let outputAlarmSpecificTimeList = BehaviorSubject<Bool>(value: false)
        let outputStartDate = BehaviorSubject<Bool>(value: false)
        let outputPeriodType = BehaviorSubject<Bool>(value: false)
        let outputSelectedPill = PublishSubject<[Pill]>()
        let outputIsCompleted = BehaviorRelay(value: false)
        let outputIsReviseItemCompleted = BehaviorRelay(value: false)
        let outputIsReviseDateCompleted = BehaviorRelay(value: false)
    }
    
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
            inputGroupId.value = value._id
            inputAlarmName.value = value.alarmName
            outputPeriodType.value = value.typeTitle
            
            // 시작 날짜 시간 초기화... ㅠㅠ
            inputStartDate.value = Calendar.current.hourMinuteInitializer(value.alarmStartDate)
            
            // 등록된 날짜 가져와서 초기화떄리기
            let alarmDateFetch = repository.fetchPillAlarmDateItem(alarmName: value.alarmName)
            let tempDateList = alarmDateFetch!.map { $0.alarmDate }
            outputAlarmDateList.value = tempDateList.map { return Calendar.current.hourMinuteInitializer($0)}
            
            // 등록된 날로부터 inputAlarmSpecificTimeList 도 같이 추출
            tempDateList.forEach({ value in
                let dateComponent = calendar.dateComponents([.hour, .minute], from: value)
                let tempInterval = (hour:dateComponent.hour!, minute:dateComponent.minute!)
                
                if !self.containsTuple(arr: self.inputAlarmSpecificTimeList.value, tup: tempInterval) {
                    self.inputAlarmSpecificTimeList.value.append(tempInterval)
                }
            })
            
            output.outputStartDate.onNext(false)
            output.outputPeriodType.onNext(false)
            output.outputAlarmSpecificTimeList.onNext(false)
            
        }
        
        //MARK: - PillAlarm 에서 공통적으로 사용하는 항목
        inputGroupId.bind { [weak self] value in
            guard let self = self else { return }
            guard let value = value else { return }
            
            outputGroupId.value = value
        }
        
        inputAlarmName.bind { [weak self] value in
            guard let self = self else { return }
            guard let value = value else { output.outputAlarmname.onNext("");return }
            
            outputAlarmName.value = value
            output.outputAlarmname.onNext(value)
        }
        
        inputSelectedPill.bind { [weak self] value in
            guard let self = self else { return }
            value.forEach { item in
                guard let item = item else { return }
                self.outputSelectedPill.value.append(item)
            }
            
            output.outputSelectedPill.onNext(self.outputSelectedPill.value)
        }
        
        inputStartDate.bind { [weak self] value in
            guard let self = self else { return }
            outputStartDate.value = value.toString(dateFormat: "yyyy년 MM월 dd일")
            output.outputStartDate.onNext(true)
            
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
            guard let outputAlarmDateList = outputAlarmDateList.value else { return }
            
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
            outputAlarmSpecificTimeList.value = Array(Set(tableDateList.flatMap{ $0 }))
            output.outputAlarmSpecificTimeList.onNext(true)
        }
        
        inputPillAlarmNameExist.bind { [weak self] value in
            guard let self = self else { return }
            guard let value = value else { return }
            
            outputPillAlarmNameExist.value = repository.fetchPillExist(alarmName: value)
        }
        
        inputHasChanged.bind { [weak self] value in
            guard let self = self else { return }
            
            outputHasChanged.value = value
        }
        
        //MARK: - Trigger 부분
        reCalculateAAlarmSpecificTimeListTrigger.bind { [weak self] value in
            guard let self = self else { return }
            guard let value = value else { return }
            
            inputAlarmSpecificTimeList.value = value
        }
        
        reCalculateAlarmDateList.bind { [weak self] value in
            guard let self = self else { return }
            guard let value = value else { return }
            
            inputPeriodType.value = value
        }
        
        createTableTrigger.bind { [weak self] value in
            guard let self = self else { return }
            
            pillAlaramRegister()
        }
        
        revisePeriodTableTrigger.bind { [weak self] value in
            guard let self = self else { return }
            
            pillAlarmPeriodReviseUpsert()
        }
        
        reviseAlarmRemoveTrigger.bind { [weak self ] value in
            guard let self = self else { return }
            guard let value = value else { return }
            
            repository.updatePillAlarmRealtionIsDelete(value) // 관계 끊기
            repository.updatePillAlarmDelete(value) // 테이블 delete
        }
        
        reviseAlarmPopUpTrigger.bind { [weak self ] value in
            guard let self = self else { return }
            guard let value = value else { return }
            guard let newAlarmModel = repository.fetchPillAlarmSpecific(_id: value) else { return }
            
            inputRegistedPillAlarm.value = newAlarmModel
        }
        
        //MARK: - Rx Transform
        // Alarm Register
        input.inputIsCompleted
            .bind(with: self) { owner, value in
                
                //TODO: - Ovservable Zip
                RxSwift.Observable
                    .combineLatest(owner.output.outputAlarmname, owner.output.outputAlarmDateList, owner.output.outputPeriodType, owner.output.outputSelectedPill)
                    .subscribe(with: self) { owner, value in
                        if !value.0.isEmpty && value.2 && value.3.count > 0 {
                            owner.output.outputIsCompleted.accept(true)
                        } else {
                            owner.output.outputIsCompleted.accept(false)
                        }
                    }
                    .disposed(by: owner.disposeBag)
            }
            .disposed(by: disposeBag)
        
        // Alarm Revise
        input.inputIsReviseItemCompleted
            .bind(with: self) { owner, value in
                
                //TODO: - Ovservable Zip
                RxSwift.Observable
                    .combineLatest(owner.output.outputPeriodType, owner.output.outputStartDate)
                    .subscribe(with: self) { owner, value in
                        
                        if value.0 || value.1 {
                            owner.output.outputIsReviseItemCompleted.accept(true)
                        } else {
                            owner.output.outputIsReviseItemCompleted.accept(false)
                        }
                    }
                    .disposed(by: owner.disposeBag)
            }
            .disposed(by: disposeBag)
        
        // Alarm Revise
        input.inputIsReviseDateCompleted
            .bind(with: self) { owner, value in
                
                owner.output.outputAlarmSpecificTimeList
                    .subscribe(with: self) { owner, value in
                        if value {
                            owner.output.outputIsReviseDateCompleted.accept(true)
                        } else {
                            owner.output.outputIsReviseDateCompleted.accept(false)
                        }
                    }
                    .disposed(by: owner.disposeBag)
            }
            .disposed(by: disposeBag)
        
        
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
        
        guard let alarmName = inputAlarmName.value else { return }
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
        // table의 Attribute를 생성하기 위함
        let alarmDate = List<PillAlarmDate>()
        alarmDateFetch.forEach { pillAlarmDate in
            alarmDate.append(pillAlarmDate)
        }
        
        let pillAlaram = PillAlarm(alarmName: alarmName, pillList: pillsList, type: inputPeriodType.rawValue, typeTitle: outputPeriodType, alarmStartDate: inputStartDate.value, alarmDate: alarmDate)
        
        // realm Table 생성
        repository.createPill(pillAlaram)
        
        // Local Notification
        //TODO: - Current Date의 Local Notification
        if let alarmDateFetchNotification = repository.fetchPillAlarmDateAndUpdateNotification(alarmName: alarmName), !alarmDateFetchNotification.isEmpty {
            userNotificationCenter.addNotificationRequest(byList: alarmDateFetchNotification)
        } else {
            print("❗️오늘 날짜에 해당되는 알림 목록이 없습니다  🥲")
        }
    }
    
    //TODO: - Pill, Alarm Date 관계 다 끊고 새로 관계 맺기. 기존 AlarmDate는 모두 isDelete처리
    private func pillAlarmPeriodReviseUpsert() {
        guard let pk = inputGroupId.value else { return }
        guard let alarmName = inputAlarmName.value else { return }
        guard let outputPeriodType = outputPeriodType.value else { return }
        
        // 기존 관계 끊기 및 isDelete
        repository.updatePillAlarmRealtionIsDelete(pk)
        
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
        
        // Upsert
        if let inputPeriodType = inputPeriodType.value {
            let newPeriodType = inputPeriodType.rawValue
            repository.upsertPillAlarm(pk: pk,alarmName: alarmName, pillList: pillsList, type: newPeriodType, typeTitle: outputPeriodType, alarmStartDate: inputStartDate.value, alarmDate: alarmDate)
        } else {
            let newPeriodType = inputRegistedPillAlarm.value!.type
            repository.upsertPillAlarm(pk: pk,alarmName: alarmName, pillList: pillsList, type: newPeriodType, typeTitle: outputPeriodType, alarmStartDate: inputStartDate.value, alarmDate: alarmDate)
        }
        
        // Local Notification
        //TODO: - Current Date의 Local Notification
        if let alarmDateFetchNotification = repository.fetchPillAlarmDateAndUpdateNotification(alarmName: alarmName), !alarmDateFetchNotification.isEmpty {
            userNotificationCenter.removeAllNotification(by: alarmDateFetchNotification)
            userNotificationCenter.addNotificationRequest(byList: alarmDateFetchNotification)
        } else {
            print("❗️오늘 날짜에 해당되는 알림 목록이 없습니다  🥲")
        }
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
            outputAlarmDateList.value = dateCalculator(startDate: inputStartDate.value,
                                                       byAdding: .day,
                                                       interval: 1)
            outputPeriodType.value = "매일"
            
            output.outputPeriodType.onNext(true)
            output.outputAlarmDateList.onNext(true)
            
        case .specificDay:
            guard let interval = inputDayOfWeekInterval.value else { return }
            
            outputAlarmDateList.value = specificDateCalculate(startDate: inputStartDate.value, interval: interval)
            let outputPeriodtype = interval.count == 7 ? "매일" :interval.map { $0.toString }.joined(separator: ",")
            outputPeriodType.value = outputPeriodtype
            
            output.outputPeriodType.onNext(true)
            output.outputAlarmDateList.onNext(true)
            
        case .period:
            guard let interval = inputDaysInterval.value else { print("?????실행되냐⭕️");return }
            outputAlarmDateList.value = dateCalculator(startDate: inputStartDate.value,
                                                       byAdding: interval.enumCase.byAdding,
                                                       interval: interval.days)
            
            let outputPeriodtype = interval.enumCase.byAdding == Calendar.Component.day && interval.days == 1 ? "매일" : "\(interval.days)\(interval.enumCase.title)"
            outputPeriodType.value = outputPeriodtype
            
            output.outputPeriodType.onNext(true)
            output.outputAlarmDateList.onNext(true)
        }
    }
    
    deinit {
        print(#function, " - ✅ PillAlaramRegisterViewModel")
    }
}
