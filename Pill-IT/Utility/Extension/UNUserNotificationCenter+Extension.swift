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
    func addNotificationRequest(by pillAlarm: PillAlarmDate){
        let content = UNMutableNotificationContent()
        content.title = "삐릿 복용 알림 - " + pillAlarm.alarmName + "🔆"
        
        
        let pillItemList = "복용약 목록 🔆 : " + pillAlarm.alarmGroup.first!.pillList.map({ value in
            return value.itemName
        }).joined(separator: ",")
        
        content.body = pillItemList
        content.sound = .default
        content.badge = 1
        
        let component = Calendar.current.dateComponents([.year, .month, .day, .hour, .minute], from: pillAlarm.alarmDate)
        let trigger = UNCalendarNotificationTrigger(dateMatching: component, repeats: false)
        
        let request = UNNotificationRequest(identifier: pillAlarm.idToString, content: content, trigger: trigger)
        
        //add
        self.add(request, withCompletionHandler: nil)
    }
}
