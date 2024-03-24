//
//  UNUserNotificationCenter+Extension.swift
//  Pill-IT
//
//  Created by JinwooLee on 3/24/24.
//

import Foundation
import UserNotifications

extension UNUserNotificationCenter {
    // Alert객체를 받아서 Noti를 만들고 NotificationCenter에 추가하는 함수
    func addNotificationRequest(by alert: PillAlarmDate){
        let content = UNMutableNotificationContent()
        content.title = alert.alarmName
        content.body = "알람 테스트다 ✅✅✅✅✅✅✅✅✅✅✅✅✅"
        content.sound = .default
        content.badge = 1
        
        let component = Calendar.current.dateComponents([.year, .month, .day, .hour, .minute], from: alert.alarmDate)
        let trigger = UNCalendarNotificationTrigger(dateMatching: component, repeats: false)
        
        let request = UNNotificationRequest(identifier: alert.idToString, content: content, trigger: trigger)
        
        //add
        self.add(request, withCompletionHandler: nil)
    }
}
