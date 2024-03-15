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
        static let clear = UIImage(named: "clear")?.withRenderingMode(.alwaysOriginal)
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
    
    enum swipeColor {
        static let more = #colorLiteral(red: 0.7803494334, green: 0.7761332393, blue: 0.7967314124, alpha: 1)
        static let edit = #colorLiteral(red: 1, green: 0.5803921569, blue: 0, alpha: 1)
        static let trash = #colorLiteral(red: 1, green: 0.2352941176, blue: 0.1882352941, alpha: 1)
    }
    
    enum swipeImage {
        static let sfSymbolLargeConfig = UIImage.SymbolConfiguration(pointSize: 25, weight: .bold, scale: .large)
        static let more = UIImage(systemName: "info.circle", withConfiguration: sfSymbolLargeConfig)
        static let edit = UIImage(systemName: "square.and.pencil", withConfiguration: sfSymbolLargeConfig)
        static let trash = UIImage(systemName: "trash", withConfiguration: sfSymbolLargeConfig)

    }
}
