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
        navigationController?.navigationBar.largeTitleTextAttributes =  [NSAttributedString.Key.foregroundColor: DesignSystem.colorSet.lightBlack,
                                                                         NSAttributedString.Key.font: UIFont(name: "your font name", size: 30) ?? UIFont.systemFont(ofSize: 30, weight: .heavy)]
        // back button
        let backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: self, action: nil) // title 부분 수정
        backBarButtonItem.tintColor = DesignSystem.colorSet.lightBlack
        navigationItem.backBarButtonItem = backBarButtonItem
        
        // rightButton
        let searchButtonItem = UIBarButtonItem(image: UIImage(systemName: "magnifyingglass"))
        searchButtonItem.tintColor = DesignSystem.colorSet.lightBlack
        
        // lefe Button
        let customButton : UIButton = {
            let view = UIButton(frame: CGRect(x: 0, y: 0, width: 150, height: 40))
            view.setTitle(" 알림 등록하기", for: .normal)
            view.titleLabel?.font = .systemFont(ofSize: 18, weight: .heavy)
            view.setTitleColor(DesignSystem.colorSet.lightBlack, for: .normal)
            view.tintColor = DesignSystem.colorSet.lightBlack
            view.backgroundColor = DesignSystem.colorSet.white
            view.setImage(UIImage(systemName: "alarm"), for: .normal)
            view.layer.borderColor = DesignSystem.colorSet.lightBlack.cgColor
            view.layer.cornerRadius = 20
            view.layer.shadowOffset = CGSize(width: 10, height: 5)
            view.layer.shadowOpacity = 0.1
            view.layer.shadowRadius = 10
            view.layer.masksToBounds = false
            
            return view
        }()

        
        navigationItem.rightBarButtonItem = searchButtonItem
        navigationItem.leftBarButtonItem = UIBarButtonItem(customView: customButton)
    }
    
}
