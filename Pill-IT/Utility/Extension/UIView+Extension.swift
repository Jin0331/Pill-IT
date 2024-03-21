//
//  UIView+Extension.swift
//  Pill-IT
//
//  Created by JinwooLee on 3/11/24.
//

import UIKit
import NVActivityIndicatorView

extension UIView {
    static var identifier: String {
        return String(describing: self)
    }
    
    
    func applyRandomGradient() {
        let gradientLayer = CAGradientLayer()
        gradientLayer.frame = bounds
        gradientLayer.colors = [randomColor().cgColor, randomColor().cgColor]
        gradientLayer.startPoint = CGPoint(x: 0, y: 0)
        gradientLayer.endPoint = CGPoint(x: 1, y: 1)
        layer.insertSublayer(gradientLayer, at: 0)
    }
    
    private func randomColor() -> UIColor {
        let randomRed = CGFloat(arc4random_uniform(256)) / 255.0
        let randomGreen = CGFloat(arc4random_uniform(256)) / 255.0
        let randomBlue = CGFloat(arc4random_uniform(256)) / 255.0
        
        return UIColor(red: randomRed, green: randomGreen, blue: randomBlue, alpha: 1.0)
    }
    
    
}



