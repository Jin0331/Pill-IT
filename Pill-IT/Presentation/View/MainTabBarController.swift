//
//  MainTabBarController.swift
//  Pill-IT
//
//  Created by JinwooLee on 3/10/24.
//

//MARK: - 해당 뷰는 MVC 패턴

import UIKit
import Toast_Swift
import NotificationCenter

final class MainTabBarController: WHTabbarController {
    
    private var firstVC : PillManagementViewController!
    private var secondVC : PillNotificationViewController!
    private let userNotificationCenter = UNUserNotificationCenter.current()
    private let repository = RealmRepository()
//    private let refresh = RefreshManager.shared
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureView()
        
        UNUserNotificationCenter.current().delegate = self
        
        //MARK: - PillNotificationContentViewController에서 secondView로 화면 전환 Closure
        // PillNotificationContentViewController > PillNotificationViewController > MainTabbarController까지 보내져온 값
        secondVC.moveTopView = { [weak self] in
            guard let self = self else { return }
            selectedIndex = 0
        }
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        configureItemDesing(tabBar: tabBar)
        
        centerButtonSize  = 70.0
        centerButtonBackroundColor =  .clear
        centerButtonBorderColor  =  #colorLiteral(red: 0.3411764801, green: 0.6235294342, blue: 0.1686274558, alpha: 1)
        centerButtonBorderWidth = 0
        centerButtonImageSize = 52
        centerButtonImage = DesignSystem.imageByGY.pillIcon
        setupCenetrButton(vPosition: 0) { [weak self] in
            guard let self = self else { return }
            let vc = RegisterPillViewController()
            vc.setupSheetPresentationLarge()
            vc.pillListDelegate = self
            
            let nav = UINavigationController(rootViewController: vc)
            
            present(nav, animated: true)
        }
    }
}

//MARK: - Timer 설정하기
extension MainTabBarController {
    
    func configureView() {
        // 추후 접근을 이용해서 수정일 일이 생길 수 있으므로, 변수에 할당해서 관리
        firstVC = PillManagementViewController()
        let firstNav = UINavigationController(rootViewController: firstVC)
        
        secondVC = PillNotificationViewController()
        
        setViewControllers([firstNav, secondVC], animated: true) // tab view 설정
    }
}

//MARK: - Delegate Action
extension MainTabBarController : PillListAction {
    func fetchPillTable() {
        print("✅ fetchPillTable")
        firstVC.viewModel.fetchPillItemTrigger.value = ()
    }
    
    func completeToast() {
        view.makeToast("복용약이 등록되었습니다 ✅", duration: 2, position: .center)
    }
}


//MARK: - local notification
extension MainTabBarController : UNUserNotificationCenterDelegate {
    func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse, withCompletionHandler completionHandler: @escaping () -> Void) {
        // Handle the notification tap here
        if response.actionIdentifier == UNNotificationDefaultActionIdentifier {
            
            let notificationIdentifier = response.notification.request.identifier
            if notificationIdentifier == "terminated" {
                selectedIndex = 0
            } else {
                selectedIndex = 1
                
                let confirmAction = UIAlertAction(title: "먹었습니다 💊", style: .default) { [weak self] (action) in
                    guard let self = self else { return }
                    guard let pk = repository.stringToObjectId(notificationIdentifier) else { return }
                    repository.updatePillAlarmisDoneTrue(pk)
                    
                    NotificationCenter.default.post(name: Notification.Name("fetchPillAlarmTableForNotification"), object: nil, userInfo: ["date": Date()])
                }
                
                let cancelAction = UIAlertAction(title: "아니요 😅", style: .cancel) { [weak self] (action) in
                    guard let _ = self else { return }
                    NotificationCenter.default.post(name: Notification.Name("fetchPillAlarmTableForNotification"), object: nil, userInfo: ["date": Date()])
                }
                confirmAction.setValue(UIColor.red, forKey: "titleTextColor")
                
                self.showAlert(title: "복용 완료", message: "복용하셨나요? 🔆", actions: [confirmAction, cancelAction])
            }

            // notification action
            switch response.actionIdentifier {
            case "piliComplete" :
                let notificationIdentifier = response.notification.request.identifier
                guard let pk = repository.stringToObjectId(notificationIdentifier) else { return }
                repository.updatePillAlarmisDoneTrue(pk)
                NotificationCenter.default.post(name: Notification.Name("fetchPillAlarmTableForNotification"), object: nil, userInfo: ["date": Date()])
            default :
                break
            }
            }
            

        completionHandler()
    }
    
    // Noti를 보내기 전에 어떤 핸들링을 해줄 것인지.
    func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        
        // 알림을 배너. 리스트. 뱃지. 사운드까지 표시하도록 설정.
        completionHandler([.banner, .list, .badge, .sound])
    }
}
                           
