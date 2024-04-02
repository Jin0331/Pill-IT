//
//  PillAlarmRegisterViewController.swift
//  Pill-IT
//
//  Created by JinwooLee on 3/14/24.
//

import UIKit
import SwipeCellKit
import Toast_Swift
import MarqueeLabel

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
    
    override func viewWillAppear(_ animated: Bool) {
        MarqueeLabel.controllerViewDidAppear(self)
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
        navigationItem.title = "🌟 복용약 알림 등록하기"
        
        let cancleBarButton = UIBarButtonItem(image: DesignSystem.sfSymbol.cancel, style: .plain, target: self, action: #selector(rightBarButtonClicked))
        
        navigationItem.rightBarButtonItem = cancleBarButton
    }
    
    @objc private func rightBarButtonClicked() {
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
                
                if self.viewModel.outputSelectedPill.value.count < 2 {
                    self.view.makeToast("1개 이상의 복용약이 있어야 합니다 🥲", duration: 2, position: .center)
                } else {
                    self.viewModel.outputSelectedPill.value.remove(at: indexPath.row)
                }
            }
            
            let cancelAction = UIAlertAction(title: "취소할래요", style: .cancel)
            confirmAction.setValue(UIColor.red, forKey: "titleTextColor")
            
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
        
        if let textField = mainView.userInputTextfield.text, textField.isEmpty {
            
            self.view.makeToast("알림 이름 설정을 완료해주세요(⏎) 🥲", duration: 1.5, position: .center)
            return
        }
        
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
            viewModel.inputStartDate.value = Calendar.current.hourMinuteInitializer(datePicker.date)
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
            
            if let pillTitle = viewModel.outputAlarmName.value, let alarmDateList = viewModel.outputAlarmDateList.value, let periodType = viewModel.outputPeriodType.value, let startDate = viewModel.outputStartDate.value, !pillTitle.isEmpty, viewModel.inputSelectedPill.value.count > 0 {
                
                let vc = PillAlarmSpecificViewController()
                vc.viewModel = viewModel

                viewModel.inputHasChanged.value = true
                
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

    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true) // 다른 곳을 터치하면 키보드 내리기
    }

    func textFieldDidEndEditing(_ textField: UITextField) {
    
        guard let text = textField.text else { return }
        let textTrimmed = text.components(separatedBy: CharacterSet.alphanumerics.inverted).joined().trimmingCharacters(in: .whitespacesAndNewlines)
        
        viewModel.inputPillAlarmNameExist.value = textTrimmed
        viewModel.outputPillAlarmNameExist.bind { [weak self] value in
            guard let self = self else { return }
            guard let value = value else { return }
            
            if value {
                view.makeToast("이미 등록된 복용약 알림 이릅입니다. \n다른 이름을 사용해주세요 🥲", duration: 2.5, position: .center)
                textField.text = nil
            } else {
                viewModel.inputAlarmName.value = textTrimmed
            }
        }
    }
    
}
