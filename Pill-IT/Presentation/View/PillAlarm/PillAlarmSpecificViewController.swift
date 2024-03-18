//
//  PillAlarmSpecificViewController.swift
//  Pill-IT
//
//  Created by JinwooLee on 3/18/24.
//

import UIKit

final class PillAlarmSpecificViewController: BaseViewController {

    let mainView = PillAlaamSpecificView()
    weak var viewModel : PillAlaramRegisterViewModel?
    
    override func loadView() {
        view = mainView

    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        
        guard let viewModel = viewModel else { return }
        
        print(viewModel.outputSelectedPill.value, "✅ SelectedPill")
        print(viewModel.inputPeriodType.value, "✅ Type")
        print(viewModel.outputPeriodType.value, "✅ TypeTitle")
        print(viewModel.outputStartDate.value, "✅ StartDate")
        print(viewModel.outputAlarmDateList.value, "✅ Date List")
        
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
