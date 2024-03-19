//
//  PeriodStartDatePickerViewController.swift
//  Pill-IT
//
//  Created by JinwooLee on 3/18/24.
//

import UIKit
import SnapKit
import Then

final class PeriodStartDatePickerViewController: BaseViewController {

    let datePicker = UIDatePicker().then {
        $0.locale = Locale(identifier: "ko_KR")
        $0.preferredDatePickerStyle = .inline
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    override func configureHierarchy() {
        view.addSubview(datePicker)
    }
    
    override func configureLayout() {
        datePicker.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }

}
