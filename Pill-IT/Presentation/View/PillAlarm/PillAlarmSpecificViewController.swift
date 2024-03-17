//
//  PillAlarmSpecificViewController.swift
//  Pill-IT
//
//  Created by JinwooLee on 3/18/24.
//

import UIKit


final class PillAlarmSpecificViewController: BaseViewController {

    weak var viewModel : PillAlaramRegisterViewModel?
    
    override func viewDidLoad() {
        super.viewDidLoad()

    }
    
    override func configureNavigation() {
        super.configureNavigation()
        
        navigationItem.title = "🗓️ 복용 알림 등록 완료하기"
        navigationController?.navigationBar.prefersLargeTitles = false
        navigationItem.rightBarButtonItem = nil
    }

    
    deinit {
        print(#function, " - ✅ PillAlaamSpecificViewController")
    }
}
