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
    func pillCreate<T:Object>(_ item : T) {
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
    func pillExist(itemSeq : Int) -> Bool {
        if realm.object(ofType: Pill.self, forPrimaryKey: itemSeq) != nil {
            return true
        } else {
            return false
        }
    }
    
    func fetchPillItem() -> [Pill] {
        let result = realm.objects(Pill.self).where {
            $0.isDeleted == false
        }
        
        return Array(result)
    }
    
    //MARK: - UPDATE
    func updatePillIsDelete(_ itemSeq : Int) {
        // target 업데이트
        do {
            try realm.write {
                realm.create(Pill.self, value: ["itemSeq": itemSeq, "isDeleted": true], update: .modified) }
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
