//
//  MainTabBarController.swift
//  Pill-IT
//
//  Created by JinwooLee on 3/10/24.
//

import UIKit
import Toast_Swift

class MainTabBarController: WHTabbarController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // 추후 접근을 이용해서 수정일 일이 생길 수 있으므로, 변수에 할당해서 관리
        let firstVC = PillListViewController()
        let firstNav = UINavigationController(rootViewController: firstVC)
        
        let secondVC = NotificationViewController()
        let secondNav = UINavigationController(rootViewController: secondVC)
        
        setViewControllers([firstNav, secondNav], animated: true)
        
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        centerButtonSize  = 60.0
        centerButtonBackroundColor =  .clear
        centerButtonBorderColor  =  #colorLiteral(red: 0.3411764801, green: 0.6235294342, blue: 0.1686274558, alpha: 1)
        centerButtonBorderWidth = 0
        centerButtonImageSize = 50
        centerButtonImage = UIImage(named: "pillIcon")
        setupCenetrButton(vPosition: 0) {
            let vc = RegisterPillViewController()
            vc.pillListDelegate = self
            
            self.present(vc, animated: true)
        }
    }
//    
//    private func configureItemDesing(tabBar : UITabBar) {
//
//        tabBar.tintColor = DesignSystem.colorSet.gray
//        tabBar.barTintColor = DesignSystem.colorSet.white
//        
//        // item 디자인
//        if let item = tabBar.items {
//            //TODO: - Active, Inactive 구현해야됨. 지금은 Inactive 상태
//            item[0].image = DesignSystem.tabbarImage.trendInactive
//            item[0].selectedImage = DesignSystem.tabbarImage.trend
//            
//            item[1].image = DesignSystem.tabbarImage.searchInactive
//            item[1].selectedImage = DesignSystem.tabbarImage.search
//            
//            item[2].image = DesignSystem.tabbarImage.portfolioInactive
//            item[2].selectedImage = DesignSystem.tabbarImage.portfolio
//            
//        }
//    }
    
}

extension MainTabBarController : PillListAction {
    func completeToast() {
        view.makeToast("복용약이 등록되었습니다 ✅", duration: 2, position: .center)
    }
}
