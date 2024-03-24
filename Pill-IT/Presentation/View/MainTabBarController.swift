//
//  MainTabBarController.swift
//  Pill-IT
//
//  Created by JinwooLee on 3/10/24.
//

import UIKit
import Toast_Swift

final class MainTabBarController: WHTabbarController {
    
    private var firstVC : PillManagementViewController!
    private var secondVC : PillNotificationViewController!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // 추후 접근을 이용해서 수정일 일이 생길 수 있으므로, 변수에 할당해서 관리
        firstVC = PillManagementViewController()
        let firstNav = UINavigationController(rootViewController: firstVC)
        
        secondVC = PillNotificationViewController()
        
        setViewControllers([firstNav, secondVC], animated: true)
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
