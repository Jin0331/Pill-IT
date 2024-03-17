//
//  PillAlarmRegisterViewController.swift
//  Pill-IT
//
//  Created by JinwooLee on 3/14/24.
//

import UIKit
import SwipeCellKit

class PillAlarmRegisterViewController: BaseViewController {

    let mainView = PillAlarmRegisterView()
    let viewModel = PillAlaramRegisterViewModel()
    private var dataSource : UICollectionViewDiffableDataSource<PillAlarmViewSection, Pill>!
    
    var collectionViewDeselectAllItems :(() -> Void)?

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
        
        
        navigationItem.rightBarButtonItem = nil
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
        print(#function, " - ✅ PillAlaramViewController")
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
       
    func dismissPresent() {
        collectionViewDeselectAllItems?()
        dismiss(animated: true)
    }
    
    func periodSelectPresent() {
        print("hihi 🥲")
        let vc = PeriodSelectViewController()
        
        vc.sendPeriodSelectButtonTitle = { [weak self] value in
            guard let self = self else { return }
            mainView.periodSelectButton.setTitle(value, for: .normal)
            mainView.periodSelectButton.setImage(UIImage(systemName: "calendar.badge.plus"), for: .normal)
            mainView.periodSelectButton.tintColor = DesignSystem.colorSet.lightBlack
        }
        
        vc.viewModel = viewModel
        let nav = UINavigationController(rootViewController: vc)
        nav.setupSheetPresentationMedium()
        
        present(nav, animated: true)
    }

    
    
}
