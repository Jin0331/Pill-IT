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
    
    func fetchPillItem() -> [Pill]? {
        let table = realm.objects(Pill.self).where {
            $0.isDeleted == false
        }
        
        return Array(table)
    }
    
    //MARK: - UPDATE
    func updatePillIsDelete(itemSeq : Int) {
        
        let table = fetchPillSpecific(itemSeq: itemSeq)!
    
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
