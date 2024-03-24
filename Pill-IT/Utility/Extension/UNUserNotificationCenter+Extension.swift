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
    
    func registedNotification() {
        // 등록된 Noti 확인하기
        UNUserNotificationCenter.current().getPendingNotificationRequests { (requests) in
            for request in requests {
                print("Notification Identifier: \(request.identifier)")
                if let trigger = request.trigger as? UNCalendarNotificationTrigger {
                    let triggerDate = trigger.nextTriggerDate()
                    print("Notification Scheduled Date: ", triggerDate ?? Date())
                } else {
                    print("Notification 없음 🥲")
                }
                // 필요한 다른 정보도 여기에서 확인할 수 있습니다
            }
        }
    }
}
