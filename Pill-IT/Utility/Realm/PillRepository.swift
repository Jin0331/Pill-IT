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
    
//    func 
    
    //MARK: - Pill Search
    func fetchPillItem() -> [Pill]? {
        let table = realm.objects(Pill.self).where {
            $0.isDeleted == false
        }
        
        return Array(table)
    }
    
    //MARK: - PillAralm Group Fetch
    func fetchPillAlarm(alarmName : String) -> [PillAlarm]? {
        let table = realm.objects(PillAlarm.self).where {
            $0.alarmName == alarmName
        }
        return Array(table)
    }
    
    //MARK: - PillAralm Group의 Date Fetch
    func fetchPillAlarmDateItem(alarmName : String) -> [PillAlarmDate]? {
        let table = realm.objects(PillAlarmDate.self).where {
            $0.alarmName == alarmName
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
    func updatePillIsDelete(itemSeq : Int) {
        
        let table = fetchPillSpecific(itemSeq: itemSeq)!
    
        // 상위 그룹에 Table count 조회 후 삭제 전 Count가 1이면 (지워지는 대상 밖에 없는 상황)
        // isDelete = true
        table.alarmGroup.forEach {
            print($0.alarmName, "⭕️⭕️⭕️⭕️⭕️⭕️⭕️⭕️") // Alarm Group Primary Key
            guard let table = fetchPillAlarm(alarmName: $0.alarmName) else { return }
            guard let pillListCount = table.first?.pillList.count else { return }
            print(pillListCount, "⭕️⭕️⭕️⭕️⭕️⭕️⭕️⭕️")
            if pillListCount < 2 {
                updatePillAlarmDelete($0.alarmName)
                print($0.alarmName, "에 포함된 Pill 없으므로 삭제됩니다. ⭕️⭕️⭕️⭕️⭕️⭕️⭕️⭕️")
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
