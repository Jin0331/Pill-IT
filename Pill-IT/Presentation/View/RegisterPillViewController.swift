//
//  RegisterPill.swift
//  Pill-IT
//
//  Created by JinwooLee on 3/7/24.
//

import UIKit

class RegisterPillViewController : BaseViewController {
        
    let mainView = RegisterPillView()
    var viewModel = RegisterPillViewModel()
    
    override func loadView() {
        self.view = mainView
        mainView.actionDelegate = self
    }

    
    override func viewDidLoad() {
    
    }

    
    override func configureView() {
        
    }
}

 
//MARK: - View Action Protocol
extension RegisterPillViewController : RegisterPillAction {
    
    func disMissPresent() {
        dismiss(animated: true)
    }
}
