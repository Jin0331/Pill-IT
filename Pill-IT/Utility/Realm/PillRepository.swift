//
//  PillRepository.swift
//  Pill-IT
//
//  Created by JinwooLee on 3/8/24.
//

import Foundation
import RealmSwift

final class RealmRepository {
    
    private let realm = try! Realm()
    
    func realmLocation() { print(realm.configuration.fileURL!) }
    
    //MARK: - CREATE
    // CREATE
    func createPill<T:Object>(_ item : T) {
        do {
            try realm.write {
                realm.add(item)
                realmLocation()
            }
        } catch {
            print(error, "- pillCreate Error")
        }
    }
    
    func upsertPillAlarm(alarmName : String, pillList : List<Pill>, type : String, typeTitle : String,
                         alarmStartDate : Date, alarmDate : List<PillAlarmDate>) {
        
        do {
            try realm.write {
                realm.create(PillAlarm.self, value: ["alarmName": alarmName, "pillList": pillList,
                                                     "type": type, "typeTitle" : typeTitle,
                                                     "alarmStartDate": alarmStartDate,
                                                     "alarmDate":alarmDate,
                                                     "upDate":Date()
                                                 ], update: .modified) }
        } catch {
            print(error)
        }
    }
    
    
    //MARK: - READ
    func fetchPillSpecific(itemSeq : Int) -> Pill? {
        let table : Pill? = realm.objects(Pill.self).where {
            $0.itemSeq == itemSeq && $0.isDeleted == false}.first
        
        return table
    }
    
    func fetchPillExist(itemSeq : Int) -> Bool {
        
        let table = fetchPillSpecific(itemSeq: itemSeq)
        
        if table != nil {
            return true
        } else {
            return false
        }
    }
    

    //MARK: - Pill Search
    func fetchPillItem() -> [Pill]? {
        let table = realm.objects(Pill.self).where {
            $0.isDeleted == false
        }
        
        return Array(table)
    }
    
    //MARK: - PillAralm Group Fetch
    func fetchPillAlarm() -> [PillAlarm]? {
        let table = realm.objects(PillAlarm.self).where {
            $0.isDeleted == false
        }
        return Array(table)
    }
    
    func fetchPillAlarm(alarmName : String) -> [PillAlarm]? {
        let table = realm.objects(PillAlarm.self).where {
            $0.alarmName == alarmName && $0.isDeleted == false
        }
        return Array(table)
    }
    
    func fetchPillAlarmSpecific(alarmName : String) -> PillAlarm?{
        guard let table = realm.object(ofType:PillAlarm.self, forPrimaryKey: alarmName) else { return nil }
        
        return table
    }
    
    //MARK: - PillAralm Group의 Date Fetch
    func fetchPillAlarmDateItem(alarmName : String) -> [PillAlarmDate]? {
        let table = realm.objects(PillAlarmDate.self).where {
            $0.alarmName == alarmName && $0.isDeleted == false
        }
        return Array(table)
    }
    
    func fetchPillAlarmDateItem(alaramDate : Date) -> [PillAlarmDate]? {
        
        let targetDate = Calendar.current.startOfDay(for: alaramDate)
        let table = realm.objects(PillAlarmDate.self).filter("alarmDate >= %@ AND alarmDate < %@", targetDate, Calendar.current.date(byAdding: .day, value: 1, to: targetDate)!)
            .where {
                $0.alarmGroup.isDeleted == false && $0.isDeleted == false
            } 
        
        return Array(table.sorted(byKeyPath: "alarmDate", ascending: true))
    }
    
    
    //MARK: - UPDATE
    func updatePillIsSelect(itemSeq : Int) {
        let table = fetchPillSpecific(itemSeq: itemSeq)!
        
        do {
            try realm.write {
                table.isSelected.toggle()
                table.upDate = Date()
            }
        } catch {
            print(error)
        }
    }
    
    func updatePillIsSelectRelease(itemSeq : Int) {
        let table = fetchPillSpecific(itemSeq: itemSeq)!
        
        do {
            try realm.write {
                table.isSelected = false
                table.upDate = Date()
            }
        } catch {
            print(error)
        }
    }
    
    //MARK: - 삭제 로직
    func updatePillAlarmRealtionIsDelete(_ alarmName : String) {
        guard let table = realm.object(ofType:PillAlarm.self, forPrimaryKey: alarmName) else { return }
        
        // 기존 존재하던 PillAlarm Table is delete True
        updatePillAlarmDateAllIsDelete(alarmName: alarmName)
        
        do {
            try realm.write {
                table.pillList.removeAll()
                table.alarmDate.removeAll()
                table.upDate = Date()
            }
        } catch {
            print(error)
        }
    }
    
    // PillAlarmDate Table에서 alarmName에 따라 isDelete 모두 true
    //MARK: - updatePillAlarmRealtionIsDelete의 하위 항목임!!!
    func updatePillAlarmDateAllIsDelete(alarmName : String) {
        guard let table = fetchPillAlarmDateItem(alarmName: alarmName) else { return }

        // 트랜잭션 시작
        try! realm.write {
            // 모든 레코드의 isDelete 값을 true로 변경
            for item in table {
                item.isDeleted = true
                item.upDate = Date()
            }
        }
        
    }
    
    func updatePillIsDelete(itemSeq : Int) {
        
        let table = fetchPillSpecific(itemSeq: itemSeq)!
        
        // 해당 Pill이 포함된 AlarmTable을 모두 가져와야 됨
        let alarmTable = Array(table.alarmGroup).filter { return $0.isDeleted == false && $0.pillList.contains(table)}
        // 만약 빈 배열 일 경우, 아직 group이 설정되지 않은 것
        if !alarmTable.isEmpty {
            // alarm Talbe을 순회하며, Pill이 isDelete가 false count 조회 후 1 이하이면 AlarmTable isDelete true
            alarmTable.forEach {
                if $0.pillList.filter({ $0.isDeleted == false }).count == 1 {
                    updatePillAlarmDelete($0.alarmName)
                    print($0.alarmName, "에 포함된 Pill 없으므로 삭제됩니다. ⭕️⭕️⭕️⭕️⭕️⭕️⭕️⭕️")
                }
            }
        }
        
        do {
            try realm.write {
                table.isDeleted = true
                table.upDate = Date()
            }
        } catch {
            print(error)
        }
    }
    
    func updatePillImage(itemSeq : Int, imagePath : String) {
        
        let table = fetchPillSpecific(itemSeq: itemSeq)!
    
        do {
            try realm.write {
                table.urlPath = imagePath
                table.upDate = Date()
            }
        } catch {
            print(error)
        }
    }
    
    func updatePillAlarmDelete(_ alarmName : String) {
        guard let table = realm.object(ofType:PillAlarm.self, forPrimaryKey: alarmName) else { return }
        
        do {
            try realm.write {
                table.isDeleted = true
                table.upDate = Date()
            }
        } catch {
            print(error)
        }
    }
    
    func updatePillAlarmDateDelete(_ _id : ObjectId) {
        guard let table = realm.object(ofType:PillAlarmDate.self, forPrimaryKey: _id) else { return }
        
        do {
            try realm.write {
                table.isDeleted = true
                table.upDate = Date()
            }
        } catch {
            print(error)
        }
    }
    
    
    
    //MARK: - REMOVE
    func removePillItem(row : Pill) {
        do {
            try realm.write {
                realm.delete(row)
            }
        } catch {
            print(error, "- removePillItem Error")
        }
    }
    
    
    
}
