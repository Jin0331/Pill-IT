//
//  BaseView.swift
//  CoinMarket
//
//  Created by JinwooLee on 2/27/24.
//

import UIKit

class BaseView: UIView {

    override init(frame: CGRect) {
        super.init(frame: frame)
        
        configureHierarchy()
        configureLayout()
        configureView()
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configureHierarchy() {
        
    }
    
    func configureLayout() {
        
    }
    
    func configureView() {
        backgroundColor = DesignSystem.colorSet.white
    }
    
}
