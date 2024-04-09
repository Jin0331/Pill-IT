//
//  PillAlarmReviseItemViewController.swift
//  Pill-IT
//
//  Created by JinwooLee on 3/22/24.
//

import UIKit
import SwipeCellKit
import RxSwift
import RxCocoa


final class PillAlarmReviseDateViewController: BaseViewController {

    let mainView = PillAlarmReviseDateView()
    weak var viewModel : PillAlaramRegisterViewModel?
    let disposeBag = DisposeBag()
    private var dataSource : UICollectionViewDiffableDataSource<PillAlarmSpecificViewSection, Date>!
    
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
    
    private func bindData() {
        guard let viewModel = viewModel else { return }
        
        viewModel.outputVisibleSpecificTimeList.bind { [weak self] value in
            guard let self = self else { return }
            updateSnapshot(value)
        }
        
        //MARK: - Rx Output
        viewModel.output.outputIsReviseDateCompleted
            .bind(with: self) { owner, value in
                owner.mainView.completeButton.isEnabled = value
                owner.mainView.completeButton.backgroundColor = value ? DesignSystem.colorSet.lightBlack : DesignSystem.colorSet.gray
                owner.isModalInPresentation = value
            }
            .disposed(by: disposeBag)
    }
    
    private func configureDataSource() {
        
        let cellRegistration = mainView.pillAlarmSpecificCellRegistration()
        dataSource = UICollectionViewDiffableDataSource(collectionView: mainView.mainCollectionView, cellProvider: { [weak self] collectionView, indexPath, itemIdentifier in
            let cell = collectionView.dequeueConfiguredReusableCell(using: cellRegistration, for: indexPath, item: itemIdentifier)
            cell.delegate = self
            
            return cell
        })
    }
    
    private func updateSnapshot(_ data : [Date]) {
        var snapshot = NSDiffableDataSourceSnapshot<PillAlarmSpecificViewSection, Date>()
        snapshot.appendSections(PillAlarmSpecificViewSection.allCases)
        snapshot.appendItems(data, toSection: .main)
        
        dataSource.apply(snapshot) // reloadData
        print("PillManageMent UpdateSnapShot ❗️❗️❗️❗️❗️❗️❗️")
    }
    
    deinit {
        print(#function, " - ✅ PillAlarmReviseDateViewController")
    }
}

//MARK: - CollectionView delegate
extension PillAlarmReviseDateViewController : UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        selectDate(isAdd: false, indexPath: indexPath)
    }
}

//MARK: - CollectionView Swipe Cell Delegate
extension PillAlarmReviseDateViewController : SwipeCollectionViewCellDelegate {
    func collectionView(_ collectionView: UICollectionView, editActionsForItemAt indexPath: IndexPath, for orientation: SwipeCellKit.SwipeActionsOrientation) -> [SwipeCellKit.SwipeAction]? {
        
        guard orientation == .right else { return nil }
        
        let deleteAction = SwipeAction(style: .destructive, title: nil) { [weak self] action, indexPath in
            guard let self = self else { return }
            guard let viewModel = viewModel else { return }
            
            if  viewModel.outputVisibleSpecificTimeList.value.count < 2 {
                view.makeToast("1개 이상의 알림이 있어야 합니다 🥲", duration: 2, position: .center)
                return
            } else  {
                viewModel.outputVisibleSpecificTimeList.value.remove(at: indexPath.row)
                let inputAlarmSpecificTimeList = viewModel.outputVisibleSpecificTimeList.value.map {
                    let temp = Calendar.current.dateComponents([.hour, .minute], from: $0)
                    if let hour = temp.hour, let minute = temp.minute {
                        return (hour, minute)
                    } else {
                        return (-99,99)
                    }}
                viewModel.inputAlarmSpecificTimeList.value = inputAlarmSpecificTimeList
                viewModel.outputAlarmSpecificTimeList.value = Array(Set(viewModel.outputAlarmSpecificTimeList.value)).sorted() // 중복제거..
            }
        }
        
        // customize the action appearance
        deleteAction.image = DesignSystem.pillAlarmSwipeImage.trash
        deleteAction.font = .systemFont(ofSize: 17, weight: .heavy)
        deleteAction.hidesWhenSelected = true
        
        return [deleteAction]
    }
}

//MARK: - Delegate Action
extension PillAlarmReviseDateViewController : PillSpecificAction {
    func addButtonAction() {
        selectDate()
    }
    
    func completeButtonAction() {
        print(#function)
        
        let confirmAction = UIAlertAction(title: "수정할래요", style: .default) { (action) in
            DispatchQueue.main.async { [weak self] in
                guard let self = self else { return }
                guard let viewModel = viewModel else { return }
                
                mainView.setActivityIndicator()
                viewModel.revisePeriodTableTrigger.value = ()

                NotificationCenter.default.post(name: Notification.Name("fetchPillAlarmTable"), object: nil)
            }
            
            DispatchQueue.main.asyncAfter(deadline: .now() + 2.5) { [weak self] in
                guard let self = self else { return }
                mainView.activityIndicator.stopAnimating()
                mainView.loadingBgView.removeFromSuperview()
                
                dismiss(animated: true)
            }
        }
        
        let cancelAction = UIAlertAction(title: "취소할래요", style: .cancel)
        confirmAction.setValue(UIColor.red, forKey: "titleTextColor")
        
        self.showAlert(title: "등록된 복용약 알림 전체 수정", message: "복용약 알림을 전체 수정하시겠습니까? 🤔", actions: [confirmAction, cancelAction])
    }
}

extension PillAlarmReviseDateViewController {
    //MARK: - 이 코드를 어찌한담??? - PillAlarmRegisterViewController 중복되는 코드 나중에 Refactoring
    func selectDate(isAdd : Bool = true, indexPath : IndexPath? = nil) {
        
        let alert = UIAlertController(title: nil, message: nil, preferredStyle: .alert)
        alert.view.tintColor = DesignSystem.colorSet.lightBlack
        
        let datePicker = UIDatePicker()
        datePicker.datePickerMode = .time
        datePicker.preferredDatePickerStyle = .wheels
        datePicker.locale = Locale(identifier: "ko_KR")
        datePicker.setValue(DesignSystem.colorSet.lightBlack, forKeyPath: "textColor")
        
        let select = UIAlertAction(title: "선택 완료", style: .default) { [weak self] action in
            guard let self = self else { return }
            guard let viewModel = viewModel else { return }
            
            let dateComponent = Calendar.current.dateComponents([.hour, .minute], from: datePicker.date)
            if let hour = dateComponent.hour, let minute = dateComponent.minute {
                // 기존에 있는 outputVisibleSpecificTimeList에서 hour, minute 추출하여 tupe형태로 바꾸고,
                // datePicker의 값 append 후 inputAlarmSpecificTimeList에 추가
                var inputAlarmSpecificTimeList = viewModel.outputVisibleSpecificTimeList.value.map {
                    let temp = Calendar.current.dateComponents([.hour, .minute], from: $0)
                    if let hour = temp.hour, let minute = temp.minute {
                        return (hour, minute)
                    } else {
                        return (-99,99)
                    }}
                
                if !viewModel.containsTuple(arr: inputAlarmSpecificTimeList, tup: (hour, minute)) {
                    if isAdd {
                        inputAlarmSpecificTimeList.append((hour, minute))
                    } else {
                        guard let indexPath = indexPath else { return }
                        inputAlarmSpecificTimeList[indexPath.row] = (hour, minute)
                    }
                    viewModel.inputAlarmSpecificTimeList.value = inputAlarmSpecificTimeList
                } else {
                    view.makeToast("중복된 알림이 있습니다. 확인해주세요 🥲", duration: 2, position: .center)
                    return
                }}}
        
        let cancle = UIAlertAction(title: "취소", style: .cancel)
        
        alert.addAction(cancle)
        alert.addAction(select)
        
        let vc = UIViewController()
        vc.view = datePicker
        alert.setValue(vc, forKey: "contentViewController")
        
        present(alert, animated: true)
    }
}
