//
//  BaseViewController.swift
//  CoinMarket
//
//  Created by JinwooLee on 2/27/24.
//

import UIKit
import RxSwift
import RxCocoa

class RxBaseViewController : BaseViewController {
    var loadBag: RxSwift.DisposeBag = DisposeBag()
    var disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
}

class BaseViewController : UIViewController {
    
    init() {
        super.init(nibName: nil, bundle: nil)
    }
    
    @available (*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureHierarchy()
        configureLayout()
        configureView()
        configureNavigation()
        bind()
    }
    
    func bind() { }
    
    func configureHierarchy() { }
    
    func configureLayout() { }
    
    func configureView() {
        
        view.backgroundColor = DesignSystem.colorSet.white
    }
    
    func configureNavigation() {
        
        // bottom border
//        navigationController?.navigationBar.shadowImage = nil
        navigationController?.navigationBar.layer.borderWidth = 0.5
        navigationController?.navigationBar.layer.borderColor = DesignSystem.colorSet.gray.cgColor
        
        // 배경색
        navigationController?.navigationBar.scrollEdgeAppearance?.backgroundColor = DesignSystem.colorSet.white
        navigationController?.navigationBar.barTintColor = DesignSystem.colorSet.white
        
        // title 크게
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationController?.navigationBar.largeTitleTextAttributes =  [NSAttributedString.Key.foregroundColor: DesignSystem.colorSet.lightBlack,
                                                                         NSAttributedString.Key.font: UIFont.systemFont(ofSize: 30, weight: .heavy)]
        
        navigationController?.navigationBar.titleTextAttributes =  [NSAttributedString.Key.foregroundColor: DesignSystem.colorSet.lightBlack]
        
        // back button
        let backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: self, action: nil) // title 부분 수정
        backBarButtonItem.tintColor = DesignSystem.colorSet.lightBlack
        navigationItem.backBarButtonItem = backBarButtonItem
        
        // rightButton
//        let searchButtonItem = UIBarButtonItem(image: DesignSystem.sfSymbol.search)
//        searchButtonItem.tintColor = DesignSystem.colorSet.lightBlack
//        navigationItem.rightBarButtonItem = searchButtonItem
    }
    
    
    func confirmChangedDisMiss(actionTitle : String) {
        let alert = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        alert.addAction(UIAlertAction(title: actionTitle, style: .destructive) { [weak self] _ in
            guard let self = self else { return }
            dismiss(animated: true)
        })
        alert.addAction(UIAlertAction(title: "취소할래요", style: .cancel, handler: nil))
        
        present(alert, animated: true, completion: nil)
    }
}
