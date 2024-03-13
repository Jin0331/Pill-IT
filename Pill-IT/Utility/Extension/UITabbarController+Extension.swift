//
//  UITabbarController+Extension.swift
//  Pill-IT
//
//  Created by JinwooLee on 3/13/24.
//

import UIKit

extension UITabBarController {
    func configureItemDesing(tabBar : UITabBar) {
        
        tabBar.tintColor = DesignSystem.colorSet.gray
        tabBar.barTintColor = DesignSystem.colorSet.white
        
        // item 디자인
        if let item = tabBar.items {
            //TODO: - Active, Inactive 구현해야됨. 지금은 Inactive 상태
            item[0].image = DesignSystem.tabbarImage.pillList
            item[1].image = DesignSystem.tabbarImage.calendar
        }
    }
}


