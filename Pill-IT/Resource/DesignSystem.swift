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
    }

    enum iconImage {
        static let clear = UIImage(named: "Clear_input")?.withRenderingMode(.alwaysOriginal)
    }
    
    enum viewLayout {
        static let borderWidth = 3.0
        static let cornerRadius = 4.0
    }
}
