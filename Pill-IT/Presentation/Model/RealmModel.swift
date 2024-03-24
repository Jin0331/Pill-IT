//
//  RealmModel.swift
//  Pill-IT
//
//  Created by JinwooLee on 3/8/24.
//

import Foundation
import RealmSwift

class PillAlarm : Object {
    @Persisted(primaryKey: true) var alarmName : String
    @Persisted var pillList : List<Pill>
    @Persisted var type : String
    @Persisted var typeTitle : String
    @Persisted var alarmStartDate : Date
    @Persisted var alarmDate : List<PillAlarmDate>
    @Persisted var regDate : Date
    @Persisted var upDate : Date
    @Persisted var isDeleted : Bool
    
    convenience init(alarmName : String, pillList: List<Pill>, type: String, typeTitle : String, alarmStartDate : Date, alarmDate: List<PillAlarmDate>) {
        self.init()
        self.alarmName = alarmName
        self.pillList = pillList
        self.type = type
        self.typeTitle = typeTitle
        self.alarmStartDate = alarmStartDate
        self.alarmDate = alarmDate
        self.regDate = Date()
        self.upDate = Date()
        self.isDeleted = false
    }
}

class PillAlarmDate : Object {
    @Persisted(primaryKey: true) var _id : ObjectId
    @Persisted var alarmName : String
    @Persisted var alarmDate : Date
    @Persisted var regDate : Date
    @Persisted var upDate : Date
    @Persisted var isPass : Bool
    @Persisted var isDone : Bool
    @Persisted var isDeleted : Bool
    
    @Persisted(originProperty: "alarmDate") var alarmGroup : LinkingObjects<PillAlarm>
    
    convenience init(alarmName : String, alarmDate: Date) {
        self.init()
        self.alarmName = alarmName
        self.alarmDate = alarmDate
        self.regDate = Date()
        self.upDate = Date()
        self.isPass = false
        self.isDone = false
        self.isDeleted = false
        self.alarmGroup = alarmGroup
    }
    
    var idToString : String {
        return _id.stringValue
    }
}

class Pill : Object {
    @Persisted(primaryKey: true) var _id : ObjectId
    @Persisted var itemSeq : Int
    @Persisted var itemName : String
    @Persisted var entpName : String
    @Persisted var entpNo : String
    @Persisted var prductType : String
    @Persisted var urlPath : String
    @Persisted var regDate : Date
    @Persisted var upDate : Date
    @Persisted var isSelected : Bool
    @Persisted var isDeleted : Bool
    
    @Persisted(originProperty: "pillList") var alarmGroup : LinkingObjects<PillAlarm>
    
    convenience init(itemSeq: Int, itemName: String, entpName: String, entpNo: String, prductType : String, urlPath: String) {
        self.init()
        self.itemSeq = itemSeq
        self.itemName = itemName
        self.entpName = entpName
        self.entpNo = entpNo
        self.prductType = prductType
        self.urlPath = urlPath
        self.regDate = Date()
        self.upDate = Date()
        self.isSelected = false
        self.isDeleted = false
        self.alarmGroup = alarmGroup
    }
    
    var urlPathToURL : URL {
        get {
            return URL(fileURLWithPath: urlPath)
        }
    }
    
}
