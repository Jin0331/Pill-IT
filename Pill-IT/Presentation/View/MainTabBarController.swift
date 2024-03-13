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
        
        setViewControllers([PillListViewController(), NotificationViewController()], animated: true)
        
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
}

extension MainTabBarController : PillListAction {
    func completeToast() {
        view.makeToast("복용약이 등록되었습니다 ✅", duration: 2, position: .center)
    }
}
