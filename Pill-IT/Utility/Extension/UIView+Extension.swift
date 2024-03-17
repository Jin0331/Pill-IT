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
    
//    func setActivityIndicator() {
//        
//        // Loading
//        lazy var loadingBgView: UIView = {
//            let bgView = UIView(frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height))
//            bgView.backgroundColor = .clear
//            
//            return bgView
//        }()
//
//        lazy var activityIndicator: NVActivityIndicatorView = {
//            let activityIndicator = NVActivityIndicatorView(frame: CGRect(x: 0, y: 0, width: 40, height: 40),
//                                                            type: .circleStrokeSpin,
//                                                            color: DesignSystem.colorSet.lightBlack,
//                                                            padding: .zero)
//            activityIndicator.translatesAutoresizingMaskIntoConstraints = false
//            
//            return activityIndicator
//        }()
//        
//        // 불투명 뷰 추가
//        addSubview(loadingBgView)
//        // activity indicator 추가
//        loadingBgView.addSubview(activityIndicator)
//        
//        NSLayoutConstraint.activate([
//            activityIndicator.centerXAnchor.constraint(equalTo: centerXAnchor),
//            activityIndicator.centerYAnchor.constraint(equalTo: centerYAnchor)
//        ])
//        
//        // 애니메이션 시작
//        activityIndicator.startAnimating()
//    }
}



