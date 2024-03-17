//
//  PeriodSelectDaysViewController.swift
//  Pill-IT
//
//  Created by JinwooLee on 3/18/24.
//

import UIKit
import SnapKit
import Then

final class PeriodSelectDaysViewController: BaseViewController {
    
    var viewModel : PillAlaramRegisterViewModel?
    var sendPeriodSelectedItem : (() -> Void)? //  PeriodSelectViewController 으로 보냄. popup 할때
    
    private var selectedFrequencyIndex : PeriodDays = PeriodDays(rawValue: 0).unsafelyUnwrapped
    
    private let dataPicker = UIPickerView().then { _ in  }
        
    override func configureView() {
        super.configureView()
        
        dataPicker.delegate = self
        dataPicker.dataSource = self
    }
    
    override func configureNavigation() {
        super.configureNavigation()
        
        navigationItem.title = "간격"
        
        let rightCompleteBarButton = UIBarButtonItem(title: "완료", style: .done, target: self, action: #selector(rightBarButtonClicked))
        rightCompleteBarButton.tintColor = DesignSystem.colorSet.lightBlack
        navigationItem.rightBarButtonItem = rightCompleteBarButton
    }

    override func configureHierarchy() {
        view.addSubview(dataPicker)
    }
    
    override func configureLayout() {
        dataPicker.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
    
    @objc private func rightBarButtonClicked() {
        guard let viewModel = viewModel else { return }
        
        let byadding = PeriodDays(rawValue: dataPicker.selectedRow(inComponent: 1)).unsafelyUnwrapped
        let day = dataPicker.selectedRow(inComponent: 0) + 1
        viewModel.inputDaysInterval.value = (byadding, day)
        sendPeriodSelectedItem?()
        
        navigationController?.popViewController(animated: true)
    }
    
    deinit {
        print("✅ PeriodSelectDaysViewController")
    }
}

//MARK: - PickerView Deleagte
extension PeriodSelectDaysViewController : UIPickerViewDelegate, UIPickerViewDataSource {
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 2
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        if component == 0 {
            
            switch selectedFrequencyIndex {
            default :
                return selectedFrequencyIndex.rows
            }
        } else {
            return PeriodDays.allCases.count
        }
        
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        
        if component == 0 {
            switch selectedFrequencyIndex {
            default :
                return "\(row+1)"
            }
        } else {
            return PeriodDays(rawValue: row).unsafelyUnwrapped.title// 첫 번째 열에는 frequencyData 배열의 값을 반환
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        if component == 1 {
            selectedFrequencyIndex = PeriodDays(rawValue: row).unsafelyUnwrapped
            pickerView.reloadComponent(0)
        }
    }
    
}
