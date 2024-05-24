//
//  UNUserNotificationCenter+Extension.swift
//  Pill-IT
//
//  Created by JinwooLee on 3/24/24.
//

import Foundation
import UserNotifications
import UIKit

extension UNUserNotificationCenter {
    
    //MARK: - 등록된 알림 출력
    func printPendingNotification() {
        UNUserNotificationCenter.current().getPendingNotificationRequests { requests in
            for request in requests {
                print("Identifier: \(request.identifier)")
                print("Title: \(request.content.title)")
                print("Body: \(request.content.body)")
                print("Trigger: \(String(describing: request.trigger))")
                print("---")
            }
        }
    }
    
    //MARK: - 알림 추가
    func addNotificationRequest(byList pillAlarmList: [PillAlarmDate]){
        
        pillAlarmList.reversed().forEach { [weak self] pillAlarm in
            guard let self = self else { return }
            addNotificationRequest(by: pillAlarm)
        }
    }
    
    func addNotificationRequest(by pillAlarm: PillAlarmDate){
        
        let content = UNMutableNotificationContent()
        content.title = "삐릿 복용 알림 - " + pillAlarm.alarmName + "🔆"
        let pillItemList = "복용약 목록 🔆 : " + pillAlarm.alarmGroup.first!.pillList.map({ value in
            return value.itemName
        }).joined(separator: ",")
        
        content.body = pillItemList
        content.sound = .default
        
        let badgeCount = UserDefaults.standard.value(forKey: "NotificationBadgeCount") as! Int + 1
        UserDefaults.standard.set(badgeCount, forKey: "NotificationBadgeCount")
        content.badge = badgeCount as NSNumber
        
        content.categoryIdentifier = "replyCategory"
        
        // notification action
        let completeAction = UNNotificationAction(identifier: "piliComplete", title: "먹었어요 🔆", options: UNNotificationActionOptions(rawValue: 0))
        
        let actionCategory = UNNotificationCategory(identifier: "replyCategory", actions: [completeAction], intentIdentifiers: [], hiddenPreviewsBodyPlaceholder: "", options: .customDismissAction)
        
        UNUserNotificationCenter.current().setNotificationCategories([actionCategory])
        
        
        // set notification
        let component = Calendar.current.dateComponents([.year, .month, .day, .hour, .minute], from: pillAlarm.alarmDate)
        let trigger = UNCalendarNotificationTrigger(dateMatching: component, repeats: false)
        let request = UNNotificationRequest(identifier: pillAlarm.idToString, content: content, trigger: trigger)
        
        //add
        self.add(request, withCompletionHandler: nil)
    }
    
    func enterTerminatedNotification() {
        let content = UNMutableNotificationContent()
        content.title = "삐릿을 강제 종료하셨네요 😭"
        content.body = "알림이 도착하지 않을 수 있습니다. 삐릿을 실행해서 예정된 알림이 도착할 수 있도록 해주세요 😅"
        content.sound = UNNotificationSound.default
        
        let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 3, repeats: false) // 3초 후에 알림
        let request = UNNotificationRequest(identifier: "terminated", content: content, trigger: trigger)
        self.add(request, withCompletionHandler: nil)
    }
    
    //MARK: - 알림 삭제
    func removeAllNotification(by pillAlarm : [PillAlarmDate]) {
        
        let removeidentifiers = pillAlarm.map{ $0.idToString }
        removePendingNotification(identifiers: removeidentifiers)
        removeDeliveredNotification(identifiers: removeidentifiers)
    }
    
    
    func removePendingNotification(identifiers: [String]){
        UNUserNotificationCenter
            .current()
            .removePendingNotificationRequests(withIdentifiers: identifiers)
    }

    // 발생된 알림 삭제
    func removeDeliveredNotification(identifiers: [String]){
        UNUserNotificationCenter
            .current()
            .removeDeliveredNotifications(withIdentifiers: identifiers)
    }
}
