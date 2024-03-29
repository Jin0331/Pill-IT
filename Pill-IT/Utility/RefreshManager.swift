//
//  RefreshManager.swift
//  Pill-IT
//
//  Created by JinwooLee on 3/29/24.
//

import Foundation
import UserNotifications

final class RefreshManager {
    static let shared = RefreshManager()
    
    private init () {}
    
    private let repository = RealmRepository()
    private let userDefaults = UserDefaults.standard
    private let userNotificationCenter = UNUserNotificationCenter.current()
    
    func timerForResetNotification() {
        
        print("백그라운드 타이머입니다 🔆🔆🔆🔆🔆🔆🔆🔆🔆")
        
        let calendar = Calendar.current
        let now = Date()
        let date = calendar.date(
            bySettingHour: 0,
            minute: 0,
            second: 0,
            of: now)!
        
        let timer = Timer(fireAt: date, interval: 24*60*60, target: self, selector: #selector(resetNotificationAction), userInfo: nil, repeats: true)
        
        RunLoop.main.add(timer, forMode: RunLoop.Mode.common)
    }
    
    @objc func resetNotificationAction() {
        let currentDate = Date()
        let dateToStringForKey = currentDate.toStringTime(dateFormat: "yyyyMMdd")
        print(dateToStringForKey, "오늘 날짜 ✅✅✅✅✅✅", userDefaults.bool(forKey: dateToStringForKey))

        
        print("Notification 등록 ✅")
        if !userDefaults.bool(forKey: dateToStringForKey) {
            userDefaults.setValue(true, forKey: dateToStringForKey)
            
            let todayDate = Date()
            let yesterDate = Calendar.current.date(byAdding: .day, value: -1, to: Date())!

            if let todayPillAlarmDateTable = repository.fetchPillAlarmDateItemIsDone(alaramDate: todayDate) {
                // 현재 날짜의 모든 알림 등록
                userNotificationCenter.addNotificationRequest(byList: todayPillAlarmDateTable)
                userNotificationCenter.printPendingNotification()
            } else { print("오늘의 알림이 없습니다 ✅") }
            
            if let yesterDatePillAlarmDateTable = repository.fetchPillAlarmDateItemIsDone(alaramDate: yesterDate) {
                // 어제 날짜의 모든 알림 삭제
                userNotificationCenter.removeAllNotification(by: yesterDatePillAlarmDateTable)
            } else { print("어제의 알림이 없습니다 ✅") }
            
            
        } else {
            print("이미 오늘의 Notification이 등록되었습니다 🥲")
            userNotificationCenter.printPendingNotification()
        }
        

    }
}
