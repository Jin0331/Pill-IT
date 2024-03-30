//
//  AppDelegate.swift
//  Pill-IT
//
//  Created by JinwooLee on 3/7/24.
//

import UIKit
import NotificationCenter
import UserNotifications
import RealmSwift

@main
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    let userNotificationCenter = UNUserNotificationCenter.current()
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        
        UNUserNotificationCenter.current().delegate = self
        let authrizationOptions = UNAuthorizationOptions(arrayLiteral: [.alert, .badge, .sound])
        
        // 사용자에게 권한을(알림에대한) 요청한다.
        // completionHandler를 통해서 에러처리를 할 수 있다. 결과값은 무시하고 에러 처리정도만 해줌.
        // 이를 통해 사용자에게 권한을 요청한다.
        userNotificationCenter.requestAuthorization(options: authrizationOptions){ _, error in
            if let error = error{
                print("ERROR: notification authrization request \(error.localizedDescription)")
            }
        }
        
        Thread.sleep(forTimeInterval: 1)
        
        // realm migration
        var _id = 0
        print(Realm.Configuration().fileURL)
        
        let configuration = Realm.Configuration(schemaVersion: 1) { migration, oldSchemeVersion in
            if oldSchemeVersion < 1 {
                print("Schema : 0 -> 1")
                migration.enumerateObjects(ofType: PillAlarm.className()) { oldObject, newObject in
                    
                    guard let new = newObject else { return }
                    guard let old = oldObject else { return }
                    
                    new["alarmName"] = old["alarmName"] as! String
                    new["_id"] = ObjectId.generate()
                }
            }
        }
        
        Realm.Configuration.defaultConfiguration = configuration
        
        return true
    }
    
    // MARK: UISceneSession Lifecycle
    
    func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
        // Called when a new scene session is being created.
        // Use this method to select a configuration to create the new scene with.
        return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
    }
    
    func application(_ application: UIApplication, didDiscardSceneSessions sceneSessions: Set<UISceneSession>) {
        // Called when the user discards a scene session.
        // If any sessions were discarded while the application was not running, this will be called shortly after application:didFinishLaunchingWithOptions.
        // Use this method to release any resources that were specific to the discarded scenes, as they will not return.
    }
    
    
}


// UNUserNotificationCenterDelegate 설정
extension AppDelegate: UNUserNotificationCenterDelegate{
    
    // Noti를 보내기 전에 어떤 핸들링을 해줄 것인지.
    func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        
        // 알림을 배너. 리스트. 뱃지. 사운드까지 표시하도록 설정.
        completionHandler([.banner, .list, .badge, .sound])
    }
    
    
    func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse, withCompletionHandler completionHandler: @escaping () -> Void) {
        completionHandler()
    }
    
}
