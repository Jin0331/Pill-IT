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
            print(error)
        }
    }
    
    //MARK: - READ
    
    enum TableError : Error {
        case noData
    }
    
    func pillExist(itemSeq : Int) -> Bool {
        if realm.object(ofType: Pill.self, forPrimaryKey: itemSeq) != nil {
            return true
        } else {
            return false
        }
    }
    
}
