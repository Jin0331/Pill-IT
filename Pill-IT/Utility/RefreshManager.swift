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
    private let defaults = UserDefaults.standard
    private let defaultsKey = "lastRefresh"
    private let calender = Calendar.current
    private let userNotificationCenter = UNUserNotificationCenter.current()
    
    
    func timerForResetNotification() {
        let calendar = Calendar.current
        let now = Date()
        let date = calendar.date(
            bySettingHour: 00,
            minute: 00,
            second: 00,
            of: now)!
        
        let timer = Timer(fireAt: date, interval: 0, target: self, selector: #selector(resetNotificationAction), userInfo: nil, repeats: false)
        
        RunLoop.main.add(timer, forMode: RunLoop.Mode.common)
    }
    
    @objc private func resetNotificationAction() {
        print("✅ 타이머 실행")
        
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

        // 목록 확인
        userNotificationCenter.printPendingNotification()
    }
}
