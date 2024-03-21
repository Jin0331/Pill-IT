//
//  PillAlarmRegisterViewController.swift
//  Pill-IT
//
//  Created by JinwooLee on 3/14/24.
//

import UIKit
import SwipeCellKit
import Toast_Swift

final class PillAlarmRegisterViewController: BaseViewController {
    
    let mainView = PillAlarmRegisterView()
    let viewModel = PillAlaramRegisterViewModel()
    private var dataSource : UICollectionViewDiffableDataSource<PillAlarmViewSection, Pill>!
    
    override func loadView() {
        view = mainView
        mainView.actionDelegate = self
        mainView.mainCollectionView.delegate = self
        mainView.userInputTextfield.delegate = self
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureDataSource()
        bindData()
        
    }
    
    private func bindData() {
        viewModel.outputSelectedPill.bind { [weak self] value in
            guard let self = self else { return }
            mainView.collectionViewchangeLayout(itemCount: value.count)
            updateSnapshot(value)
            
            if value.count < 1 { dismiss(animated: true)}
        }
        
        viewModel.outputStartDate.bind { [weak self] value in
            guard let self = self else { return }
            
            mainView.startDateButton.setTitle(value, for: .normal)
        }
    }
    
    override func configureNavigation() {
        super.configureNavigation()
        navigationItem.title = "🌟 복용약 등록하기"
        
        let cancleBarButton = UIBarButtonItem(image: DesignSystem.sfSymbol.cancel, style: .plain, target: self, action: #selector(rightBarButtonClicked))
        
        navigationItem.rightBarButtonItem = cancleBarButton
    }
    
    @objc private func rightBarButtonClicked() {
        print("ASDasdzxcad  🥲")
        dismiss(animated: true)
    }
    
    private func configureDataSource() {
        
        let cellRegistration = mainView.pillAlarmCellRegistration()
        dataSource = UICollectionViewDiffableDataSource(collectionView: mainView.mainCollectionView, cellProvider: { [weak self] collectionView, indexPath, itemIdentifier in
            let cell = collectionView.dequeueConfiguredReusableCell(using: cellRegistration, for: indexPath, item: itemIdentifier)
            cell.delegate = self
            
            return cell
        })
    }
    
    private func updateSnapshot(_ data : [Pill]) {
        var snapshot = NSDiffableDataSourceSnapshot<PillAlarmViewSection, Pill>()
        snapshot.appendSections(PillAlarmViewSection.allCases)
        snapshot.appendItems(data, toSection: .main)
        
        dataSource.apply(snapshot) // reloadData
        
        print(#function, "PillAlarm UpdateSnapShot ❗️❗️❗️❗️❗️❗️❗️")
    }
    
    
    deinit {
        print(#function, " - ✅ PillAlarmRegisterViewController")
    }
}


extension PillAlarmRegisterViewController : UICollectionViewDelegate {
    
}

//MARK: - CollectionView swipe delegate
extension PillAlarmRegisterViewController : SwipeCollectionViewCellDelegate {
    func collectionView(_ collectionView: UICollectionView, editActionsForItemAt indexPath: IndexPath, for orientation: SwipeCellKit.SwipeActionsOrientation) -> [SwipeCellKit.SwipeAction]? {
        guard orientation == .right else { return nil }
        
        let deleteAction = SwipeAction(style: .destructive, title: nil) { [weak self] action, indexPath in
            guard let self = self else { return }
            
            let confirmAction = UIAlertAction(title: "지워주세요", style: .default) { (action) in
                self.viewModel.outputSelectedPill.value.remove(at: indexPath.row)
            }
            
            let cancelAction = UIAlertAction(title: "취소할래요", style: .cancel)
            cancelAction.setValue(UIColor.red, forKey: "titleTextColor")
            
            self.showAlert(title: "등록된 복용약 삭제", message: "등록된 복용약 삭제하시겠습니까? 🥲", actions: [confirmAction, cancelAction])
        }
        
        // customize the action appearance
        deleteAction.image = DesignSystem.pillAlarmSwipeImage.trash
        deleteAction.font = .systemFont(ofSize: 17, weight: .heavy)
        deleteAction.hidesWhenSelected = true
        
        return [deleteAction]
    }
    
    func collectionView(_ collectionView: UICollectionView, editActionsOptionsForItemAt indexPath: IndexPath, for orientation: SwipeActionsOrientation) -> SwipeOptions {
        var options = SwipeOptions()
        options.transitionStyle = .reveal
        options.backgroundColor = DesignSystem.colorSet.white
        
        return options
    }
    
    
    
}

//MARK: - Delegate Action
extension PillAlarmRegisterViewController : PillAlarmReigsterAction {
    
    func periodSelectPresent() {
        let vc = PeriodSelectViewController()
        
        vc.sendPeriodSelectButtonTitle = { [weak self] value in
            guard let self = self else { return }
            mainView.periodSelectButton.setTitle(value, for: .normal)
            mainView.periodSelectButton.setImage(DesignSystem.sfSymbol.startDate, for: .normal)
            mainView.periodSelectButton.tintColor = DesignSystem.colorSet.lightBlack
        }
        
        vc.viewModel = viewModel
        let nav = UINavigationController(rootViewController: vc)
        nav.setupSheetPresentationMedium()
        
        present(nav, animated: true)
    }
    
    func startDateSelectPresent() {
        
        // 이 코드를 어찌한담???
        let alert = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        alert.view.tintColor = DesignSystem.colorSet.lightBlack
        
        let datePicker = UIDatePicker()
        datePicker.datePickerMode = .date
        datePicker.preferredDatePickerStyle = .inline
        datePicker.locale = Locale(identifier: "ko_KR")
        datePicker.setValue(DesignSystem.colorSet.lightBlack, forKeyPath: "textColor")
        
        let select = UIAlertAction(title: "선택 완료", style: .cancel) { [weak self] action in
            guard let self = self else { return }
            viewModel.inputStartDate.value = datePicker.date
        }
        
        alert.addAction(select)
        let vc = UIViewController()
        vc.view = datePicker
        alert.setValue(vc, forKey: "contentViewController")
        
        present(alert, animated: true)
    }
    
    func completeButtonAction() {
        
        DispatchQueue.main.async { [weak self] in
            guard let self = self else { return }
            mainView.setActivityIndicator()
        }
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) { [weak self] in
            guard let self = self else { return }
            mainView.activityIndicator.stopAnimating()
            mainView.loadingBgView.removeFromSuperview()
            
            print(viewModel.inputGroupId.value)
            
            
            if let pillTitle = viewModel.inputGroupId.value, let alarmDateList = viewModel.outputAlarmDateList.value, let periodType = viewModel.outputPeriodType.value, let startDate = viewModel.outputStartDate.value, !pillTitle.isEmpty, viewModel.selectedPill.value.count > 0 {
                
                let vc = PillAlarmSpecificViewController()
                vc.viewModel = viewModel

                navigationController?.pushViewController(vc, animated: true)
                
            } else {
                view.makeToast("입력된 값을 다시 확인해주세요 🥲", duration: 2, position: .center)
            }
        }
    }
    
}

//MARK: - Textfield Delegate
extension PillAlarmRegisterViewController : UITextFieldDelegate {
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        print(#function)
        textField.text = nil
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        
        return true
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        
        viewModel.inputGroupId.value = textField.text
    }
    
}
