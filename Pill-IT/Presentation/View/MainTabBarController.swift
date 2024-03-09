//
//  MainTabBarController.swift
//  Pill-IT
//
//  Created by JinwooLee on 3/10/24.
//

import UIKit
import WHTabbar

class MainTabBarController: WHTabbarController {
    

    override func viewDidLoad() {
        super.viewDidLoad()

        setViewControllers([NotificationViewController(), PillListViewController()], animated: true)
    
    }
    
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        centerButtonSize  = 60.0
        centerButtonBackroundColor =  .clear
        centerButtonBorderColor  =  #colorLiteral(red: 0.3411764801, green: 0.6235294342, blue: 0.1686274558, alpha: 1)
        centerButtonBorderWidth = 0
        centerButtonImageSize = 50
        centerButtonImage = UIImage(named: "pillIcon")
        
        
        
        // vPosition +ev value will move button Up
        // vPosition -ev value will move button Down
        setupCenetrButton(vPosition: 0) {
            print("center button clicked")
            self.present(RegisterPillViewController(), animated: true)
            
            // you can navigate to some view controler from here
            
            // or you can enable the babbar selected item jsut like
           // self.tabBarController?.selectedIndex = 1
        }
        
        
    }
}
