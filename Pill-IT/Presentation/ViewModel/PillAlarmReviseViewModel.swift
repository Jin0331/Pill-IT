//
//  PillAlarmReviseViewModel.swift
//  Pill-IT
//
//  Created by JinwooLee on 3/22/24.
//

import Foundation
import RealmSwift

class PillAlarmReviseViewModel {
    
    private let repository = RealmRepository()
    
    var inputPillAlarm : Observable<PillAlarm?> = Observable(nil)
    
    init() {
        transform()
    }
    
    private func transform() {
        
    }
}
