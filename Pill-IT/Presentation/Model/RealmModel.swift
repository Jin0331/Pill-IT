//
//  RealmModel.swift
//  Pill-IT
//
//  Created by JinwooLee on 3/8/24.
//

import Foundation
import RealmSwift

class PillAlarm : Object {
    
    @Persisted(primaryKey: true) var groupID : ObjectId
    @Persisted var pillList : List<Pill>
    @Persisted var type : Int
    @Persisted var alarmDate : List<Date>
    @Persisted var alarmStartDate : Date
    @Persisted var alarmEndtDate : Date
    @Persisted var regDate : Date
    @Persisted var upDate : Date
    @Persisted var isDeleted : Bool
    
    convenience init(groupID: ObjectId, pillList: List<Pill>, type: Int, alarmDate: List<Date>, alarmStartDate: Date, alarmEndtDate: Date, regDate: Date, upDate: Date, isDeleted: Bool) {
        self.init()
        self.groupID = groupID
        self.pillList = pillList
        self.type = type
        self.alarmDate = alarmDate
        self.alarmStartDate = alarmStartDate
        self.alarmEndtDate = alarmEndtDate
        self.regDate = Date()
        self.upDate = Date()
        self.isDeleted = false
    }
    
}
 

class Pill : Object {
    
    @Persisted(primaryKey: true) var itemSeq : Int
    @Persisted var itemName : String
    @Persisted var urlPath : String
    @Persisted var regDate : Date
    @Persisted var upDate : Date
    @Persisted var isDeleted : Bool
    
    @Persisted(originProperty: "pillList") var alarmGroup : LinkingObjects<PillAlarm>
    
    convenience init(itemSeq: Int, itemName: String, urlPath: String, regDate: Date, upDate: Date, isDeleted: Bool) {
        self.init()
        self.itemSeq = itemSeq
        self.itemName = itemName
        self.urlPath = urlPath
        self.regDate = Date()
        self.upDate = Date()
        self.isDeleted = false
        self.alarmGroup = alarmGroup
    }
    
    
}
