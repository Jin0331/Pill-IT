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
        
        let table : Pill? = realm.objects(Pill.self).where {
            $0.itemSeq == itemSeq && $0.isDeleted == false}.first
        
        if table != nil {
            return true
        } else {
            return false
        }
    }
    
    func fetchPillItem() -> [Pill] {
        let table = realm.objects(Pill.self).where {
            $0.isDeleted == false
        }
        
        return Array(table)
    }
    
    //MARK: - UPDATE
    func updatePillIsDelete(_ itemSeq : Int) {
        
        let table = realm.objects(Pill.self).where {
            $0.itemSeq == itemSeq}.first!
    
        do {
            try realm.write {
                table.isDeleted = true
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
