//
//  PillAlarmReviseDateViewController.swift
//  Pill-IT
//
//  Created by JinwooLee on 3/22/24.
//

import UIKit
import RxSwift
import RxCocoa
import SwipeCellKit
import Toast_Swift
import MarqueeLabel

final class PillAlarmReviseItemViewController: BaseViewController {
    
    let mainView = PillAlarmReviseItemView()
    var viewModel : PillAlaramRegisterViewModel?
    let disposeBag = DisposeBag()
    private var dataSource : UICollectionViewDiffableDataSource<PillAlarmViewSection, Pill>!
    
    override func loadView() {
        view = mainView
        mainView.actionDelegate = self
        mainView.mainCollectionView.delegate = self
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
        
        guard let viewModel = viewModel else { print("PillAlarmReviseItemViewController - viewModel not init 🥲");return }
        
        viewModel.outputSelectedPill.bind { [weak self] value in
            guard let self = self else { return }
            mainView.collectionViewchangeLayout(itemCount: value.count)
            updateSnapshot(value)
            
            if value.count < 1 {
                dismiss(animated: true)
            }
        }
        
        viewModel.outputPeriodType.bind { [weak self] value in
            guard let self = self else { return }
            guard let value = value else { return }
            
            mainView.periodSelectButton.setTitle(value, for: .normal)
            mainView.periodSelectButton.setImage(DesignSystem.sfSymbol.startDate, for: .normal)
            mainView.periodSelectButton.tintColor = DesignSystem.colorSet.lightBlack
            
        }
        
        viewModel.outputStartDate.bind { [weak self] value in
            guard let self = self else { return }
            
            mainView.startDateButton.setTitle(value, for: .normal)
        }
        
        //MARK: - Rx Output
        viewModel.output.outputIsReviseItemCompleted
            .bind(with: self) { owner, value in
                owner.mainView.completeButton.isEnabled = value
                owner.mainView.completeButton.backgroundColor = value ? DesignSystem.colorSet.lightBlack : DesignSystem.colorSet.gray
                owner.isModalInPresentation = value
            }
            .disposed(by: disposeBag)
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
        print(#function, " - ✅ PillAlarmReviseItemViewController")
    }
    
}

extension PillAlarmReviseItemViewController : UICollectionViewDelegate {
    
}

//MARK: - CollectionView swipe delegate
extension PillAlarmReviseItemViewController : SwipeCollectionViewCellDelegate {
    func collectionView(_ collectionView: UICollectionView, editActionsForItemAt indexPath: IndexPath, for orientation: SwipeCellKit.SwipeActionsOrientation) -> [SwipeCellKit.SwipeAction]? {
        guard orientation == .right else { return nil }
        
        let deleteAction = SwipeAction(style: .destructive, title: nil) { [weak self] action, indexPath in
            guard let self = self else { return }
            guard let viewModel = viewModel else { print("PillAlarmReviseItemViewController - viewModel not init 🥲");return }
            
            let confirmAction = UIAlertAction(title: "지워주세요", style: .default) { (action) in
                if viewModel.outputSelectedPill.value.count < 2 {
                    self.view.makeToast("1개 이상의 복용약이 있어야 합니다 🥲", duration: 2, position: .center)
                } else {
                    // 이미 outdate를 기존의 selectedPill로 생성을 해두었는데, outputselectPill만 수정하니, ouitputdate의 값은 지워지지 않기 떄문에, 중복되어 나타난다
                    viewModel.outputSelectedPill.value.remove(at: indexPath.row)
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
extension PillAlarmReviseItemViewController : PillAlarmReigsterAction {
    
    func periodSelectPresent() {
        let vc = PeriodSelectViewController()
        
        vc.sendPeriodSelectButtonTitle = { [weak self] value in
            guard let self = self else { return }
            guard let viewModel = viewModel else { return }
            mainView.periodSelectButton.setTitle(value, for: .normal)
            mainView.periodSelectButton.setImage(DesignSystem.sfSymbol.startDate, for: .normal)
            mainView.periodSelectButton.tintColor = DesignSystem.colorSet.lightBlack
            
            viewModel.reCalculateAAlarmSpecificTimeListTrigger.value = viewModel.inputAlarmSpecificTimeList.value
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
            guard let viewModel = viewModel else { print("PillAlarmReviseItemViewController - viewModel not init 🥲");return }
            
            if let _ = viewModel.inputPeriodType.value {
                viewModel.inputStartDate.value = Calendar.current.hourMinuteInitializer(datePicker.date)
            } else {
                // 수정 상태 - inputPeriodType이 없는 경우(default)
                // 날짜를 직접 계산 해서 output Date를 계산한다.
                // 즉 주기가 원래 상태 그대라는 것. 데이트를 더하거나 빼면 될 듯.
                // outputDate실행까지는 되고, period를 통해 날짜를 재계산 하는 부분만 짜면 됨
                guard  let outputAlarmDateList = viewModel.outputAlarmDateList.value else { return }
                let gap = Calendar.current.getDateGap(from: viewModel.inputStartDate.value, to: Calendar.current.hourMinuteInitializer(datePicker.date))
                
                let newOutputAlarmDateList = outputAlarmDateList.map({
                    return Calendar.current.date(byAdding: .day, value: gap, to: $0)!
                })
                
                viewModel.outputAlarmDateList.value = Array(Set(newOutputAlarmDateList)) // 중복 제거
                viewModel.inputStartDate.value = Calendar.current.hourMinuteInitializer(datePicker.date)
                viewModel.reCalculateAAlarmSpecificTimeListTrigger.value = viewModel.inputAlarmSpecificTimeList.value
            }
        }
        
        alert.addAction(select)
        let vc = UIViewController()
        vc.view = datePicker
        alert.setValue(vc, forKey: "contentViewController")
        
        present(alert, animated: true)
    }
    
    func completeButtonAction() {
        
        let confirmAction = UIAlertAction(title: "수정할래요", style: .default) { (action) in
            DispatchQueue.main.async { [weak self] in
                guard let self = self else { return }
                mainView.setActivityIndicator()
            }
            
            DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) { [weak self] in
                guard let self = self else { return }
                guard let viewModel = viewModel else { print("PillAlarmReviseItemViewController - viewModel not init 🥲");return }
                mainView.activityIndicator.stopAnimating()
                mainView.loadingBgView.removeFromSuperview()
                
                
                if let pillTitle = viewModel.inputAlarmName.value, let alarmDateList = viewModel.outputAlarmDateList.value, let periodType = viewModel.outputPeriodType.value, let startDate = viewModel.outputStartDate.value, !pillTitle.isEmpty, viewModel.inputSelectedPill.value.count > 0 {
                    viewModel.revisePeriodTableTrigger.value = ()
                    NotificationCenter.default.post(name: Notification.Name("fetchPillAlarmTable"), object: nil)
                    
                    dismiss(animated: true)
                }
            }
        }
        
        let cancelAction = UIAlertAction(title: "취소할래요", style: .cancel)
        confirmAction.setValue(UIColor.red, forKey: "titleTextColor")
        
        self.showAlert(title: "등록된 복용약 알림 전체 수정", message: "복용약 알림을 전체 수정하시겠습니까? 🤔", actions: [confirmAction, cancelAction])
    }
    
}
