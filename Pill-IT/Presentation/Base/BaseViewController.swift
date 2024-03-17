//
//  BaseViewController.swift
//  CoinMarket
//
//  Created by JinwooLee on 2/27/24.
//

import UIKit

class BaseViewController : UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureHierarchy()
        configureLayout()
        configureView()
        configureNavigation()
    }
    
    func configureHierarchy() {
        
    }
    
    func configureLayout() {
        
    }
    
    func configureView() {
        
        view.backgroundColor = DesignSystem.colorSet.white
    }
    
    func configureNavigation() {
        
        // bottom border
        navigationController?.navigationBar.shadowImage = nil
        
        // 배경색
        navigationController?.navigationBar.scrollEdgeAppearance?.backgroundColor = DesignSystem.colorSet.white
        navigationController?.navigationBar.barTintColor = DesignSystem.colorSet.white
        
        // title 크게
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationController?.navigationBar.largeTitleTextAttributes =  [NSAttributedString.Key.foregroundColor: DesignSystem.colorSet.lightBlack,                                                                         NSAttributedString.Key.font: UIFont.systemFont(ofSize: 30, weight: .heavy)]
        
        navigationController?.navigationBar.titleTextAttributes =  [NSAttributedString.Key.foregroundColor: DesignSystem.colorSet.lightBlack]
        
        // back button
        let backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: self, action: nil) // title 부분 수정
        backBarButtonItem.tintColor = DesignSystem.colorSet.lightBlack
        navigationItem.backBarButtonItem = backBarButtonItem
        
        // rightButton
        let searchButtonItem = UIBarButtonItem(image: UIImage(systemName: "magnifyingglass"))
        searchButtonItem.tintColor = DesignSystem.colorSet.lightBlack
        navigationItem.rightBarButtonItem = searchButtonItem
    }
    
}
