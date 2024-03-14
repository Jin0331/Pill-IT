//
//  AlarmViewController.swift
//  Pill-IT
//
//  Created by JinwooLee on 3/14/24.
//

import UIKit

class AlarmViewController: BaseViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = .pillpurple
    }
    
    override func configureNavigation() {
        super.configureNavigation()
        
        
        navigationItem.rightBarButtonItem = nil
    }
}
