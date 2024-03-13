//
//  ImageSystem.swift
//  CoinMarket
//
//  Created by JinwooLee on 2/27/24.
//

import UIKit

enum DesignSystem {
    
    enum colorSet  {
        static let black = UIColor.pillBlack
        static let lightBlack = UIColor.pillLightBlack
        static let gray = UIColor.pillGray
        static let lightGray = UIColor.pillLightGray
        static let red = UIColor.pillRed
        static let white = UIColor.pillWhite
        static let purple = UIColor.pillpurple
    }

    enum iconImage {
        static let clear = UIImage(named: "Clear_input")?.withRenderingMode(.alwaysOriginal)
    }
    
    enum viewLayout {
        static let borderWidth = 1.5
        static let cornerRadius = 6.0
        static let imageCornetRadius = 8.0
    }
    
    enum tabbarImage {
        static let pillList = UIImage(named: "tab_list_inactive")
        static let calendar = UIImage(named: "tab_notification_inactive")
    }
}
