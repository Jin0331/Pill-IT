//
//  PillListViewController.swift
//  Pill-IT
//
//  Created by JinwooLee on 3/10/24.
//

import UIKit
import SearchTextField
import SnapKit
import Then
import SwipeCellKit

final class PillManagementViewController : BaseViewController {
    
    let mainView = PillManagementView()
    let viewModel = PillManagementViewModel()
    private var dataSource : UICollectionViewDiffableDataSource<PillManagementViewSection, Pill>!
    
    override func loadView() {
        view = mainView
        mainView.mainCollectionView.delegate = self
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(true)
        
        print(#function)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        bindData()
    }
    
    private func bindData() {
        viewModel.outputRegisteredPill.bind { [weak self] value in
            guard let self = self else { return }
            guard let value = value else { return }
            
            configureDataSource()
            updateSnapshot(value)
//            updateSnapshot()
        }
    }
    
    override func configureNavigation() {
        super.configureNavigation()
        navigationItem.title = "🥲 나의 복용약"
        
        mainView.customButton.addTarget(self, action: #selector(leftBarButtonClicked), for: .touchUpInside)
        navigationItem.leftBarButtonItem = UIBarButtonItem(customView: mainView.customButton)
        if #available(iOS 16.0, *) {
            navigationItem.leftBarButtonItem?.isHidden = true
        } else {
            // Fallback on earlier versions
            navigationItem.leftBarButtonItem?.customView?.isHidden = true
        }
    }
    
    private func configureDataSource() {
        
        let cellRegistration = mainView.pillManagementCellRegistration()
        dataSource = UICollectionViewDiffableDataSource(collectionView: mainView.mainCollectionView, cellProvider: { collectionView, indexPath, itemIdentifier in
            let cell = collectionView.dequeueConfiguredReusableCell(using: cellRegistration, for: indexPath, item: itemIdentifier)
            cell.delegate = self
            
            return cell
        })
    }
    
    private func updateSnapshot(_ data : [Pill]) {
        var snapshot = NSDiffableDataSourceSnapshot<PillManagementViewSection, Pill>()
        snapshot.appendSections(PillManagementViewSection.allCases)
        snapshot.appendItems(data, toSection: .main)
        
        dataSource.apply(snapshot) // reloadData
        
        print(#function, "PillManageMent UpdateSnapShot ❗️❗️❗️❗️❗️❗️❗️")
    }
    
//    private func updateSnapshot() {
//        
//        guard let data = viewModel.outputRegisteredPill.value else { return }
//        var snapshot = NSDiffableDataSourceSnapshot<PillManagementViewSection, Pill>()
//        snapshot.appendSections(PillManagementViewSection.allCases)
//        snapshot.appendItems(data, toSection: .main)
//        
//
//
//        dataSource.apply(snapshot) // reloadData
//        
//        print(#function, "PillManageMent UpdateSnapShot ❗️❗️❗️❗️❗️❗️❗️")
//    }
    
    //MARK: - 복용약 알림 화면으로 이동하는 부분
    @objc func leftBarButtonClicked(_ sender : UIBarButtonItem){
        let vc =  PillAlarmRegisterViewController()
        vc.setupSheetPresentationLarge()
        
        guard let selectedIndexPaths = mainView.mainCollectionView.indexPathsForSelectedItems else { return }
        let selectedPill = selectedIndexPaths.map{ return dataSource.itemIdentifier(for: $0)}
        
        vc.viewModel.selectedPill.value = selectedPill
        vc.collectionViewDeselectAllItems = { [weak self] in
            guard let self = self else { return }
//            mainView.mainCollectionView.deselectAllItems(animated: true)
        }
        
        present(vc, animated: true)
        
    }
    
    deinit {
        print(#function, " - ✅ PillManagementViewController")
    }
}

//MARK: - Collection View Delegate
extension PillManagementViewController : UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if let cell = collectionView.cellForItem(at: indexPath) as? PillManagementCollectionViewCell {
            cell.showSelectedImage()
            hiddenLeftBarButton(collectionView)
        }
    }
    
    
    func collectionView(_ collectionView: UICollectionView, didDeselectItemAt indexPath: IndexPath) {
        if let cell = collectionView.cellForItem(at: indexPath) as? PillManagementCollectionViewCell {
            cell.hiddneSelectedImage()
            hiddenLeftBarButton(collectionView)
        }
    }
    
    // version 대응
    // IOS 15에서는 navigationItem.leftBarButtonItem?.isHidden 없음
    private func hiddenLeftBarButton(_ collectionView : UICollectionView) {
        if let isAllHideen = collectionView.indexPathsForSelectedItems, isAllHideen.isEmpty {
            if #available(iOS 16.0, *) {
                navigationItem.leftBarButtonItem?.isHidden = true
            } else {
                navigationItem.leftBarButtonItem?.customView?.isHidden = true
            }
        } else {
            if #available(iOS 16.0, *) {
                navigationItem.leftBarButtonItem?.isHidden = false
            } else {
                // Fallback on earlier versions
                navigationItem.leftBarButtonItem?.customView?.isHidden = false
            }
        }
    }
}

//MARK: - CollectionView swipe delegate
extension PillManagementViewController : SwipeCollectionViewCellDelegate {
    func collectionView(_ collectionView: UICollectionView, editActionsForItemAt indexPath: IndexPath, for orientation: SwipeCellKit.SwipeActionsOrientation) -> [SwipeCellKit.SwipeAction]? {
        guard orientation == .right else { return nil }
        
        let deleteAction = SwipeAction(style: .destructive, title: "삭제") { [weak self] action, indexPath in
            guard let self = self else { return }
            
            let confirmAction = UIAlertAction(title: "지워주세요", style: .default) { (action) in
                self.viewModel.updatePillItemisDeleteTrigger.value = self.dataSource.itemIdentifier(for: indexPath)
            }
            
            let cancelAction = UIAlertAction(title: "취소할래요", style: .cancel)
            cancelAction.setValue(UIColor.red, forKey: "titleTextColor")
            
            self.showAlert(title: "등록된 복용약 삭제", message: "등록된 복용약 삭제하시겠습니까? 🥲", actions: [confirmAction, cancelAction])
            
            
        }
        
        let editImageAction = SwipeAction(style: .default, title: "이미지 수정") { [weak self] action, indexPath in
            guard let self = self else { return }
            let vc = RegisterPillViewController()
            vc.modifyView(itemSeq: dataSource.itemIdentifier(for: indexPath)?.itemSeq.toString)
            vc.pillListDelegate = self
            vc.setupSheetPresentationLarge()
            
            present(vc, animated: true)
        }
        
        let moreInfoAction = SwipeAction(style: .default, title: "정보") { action, indexPath in
            print("더보기")
            //TODO: - local Notification 완료 후 진행
        }
        
        // customize the action appearance
        deleteAction.image = DesignSystem.pillManagementSwipeImage.trash
        editImageAction.image = DesignSystem.pillManagementSwipeImage.edit
        moreInfoAction.image = DesignSystem.pillManagementSwipeImage.more
        
        editImageAction.backgroundColor = DesignSystem.swipeColor.edit
        moreInfoAction.backgroundColor = DesignSystem.swipeColor.more
        
        deleteAction.font = .systemFont(ofSize: 17, weight: .heavy)
        editImageAction.font = .systemFont(ofSize: 17, weight: .heavy)
        moreInfoAction.font = .systemFont(ofSize: 17, weight: .heavy)
        
        deleteAction.hidesWhenSelected = true
        editImageAction.hidesWhenSelected = true
        moreInfoAction.hidesWhenSelected = true
        
        return [deleteAction, editImageAction, moreInfoAction]
    }
    
    func collectionView(_ collectionView: UICollectionView, editActionsOptionsForItemAt indexPath: IndexPath, for orientation: SwipeActionsOrientation) -> SwipeOptions {
        var options = SwipeOptions()
        options.transitionStyle = .reveal
        options.backgroundColor = DesignSystem.colorSet.white
        
        return options
    }
    
}

//MARK: - Delegate Action
extension PillManagementViewController : PillListAction {
    func fetchPillTable() {
        print("✅ fetchPillTable")
        viewModel.fetchPillItemTrigger.value = ()
    }
    
    func completeToast() {
        view.makeToast("복용약이 수정되었습니다 ✅", duration: 2, position: .center)
    }
}
