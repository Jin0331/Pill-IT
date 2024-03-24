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
import MarqueeLabel

final class PillManagementViewController : BaseViewController {
    
    let mainView = PillManagementView()
    let viewModel = PillManagementViewModel()
    private var headerDataSource : UICollectionViewDiffableDataSource<PillManagementViewSection, PillAlarm>!
    private var mainDataSource : UICollectionViewDiffableDataSource<PillManagementViewSection, Pill>!
    
    override func loadView() {
        view = mainView
        mainView.mainCollectionView.delegate = self
        mainView.headerCollecionView.delegate = self
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        bindData()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        print(#function, "❗️PillManagementViewController")
        selectedCellRelease()
        MarqueeLabel.controllerViewDidAppear(self)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        print(#function, "⭕️ Tabbar 전환")
        for cell in mainView.mainCollectionView.visibleCells {
            if let cell = cell as? SwipeCollectionViewCell {
                cell.hideSwipe(animated: true)
            }
        }
        mainView.mainCollectionView.deselectAllItems(animated: true)
        
        // notificaionCenter remove
//        NotificationCenter.default.removeObserver(self,
//                                                  name: Notification.Name("fetchPillAlarmTable"), object: nil)
    }
    private func bindData() {
        // 복용약 리스트
        viewModel.outputRegisteredPill.bind { [weak self] value in
            guard let self = self else { return }
            guard let value = value else { return }
            
            // emptyView
            mainView.emptyViewisHidden(itemCount: value.count)
            
            configureMainDataSource()
            updateMainSnapshot(value)
            
        }
        
        // 복용약 그룹 리스트
        viewModel.outputRegisteredPillAlarm.bind { [weak self] value in
            guard let self = self else { return }
            guard let value = value else { return }
            
            mainView.headercollectionViewChangeLayout(itemCount: value.count)
            
            configureHeaderDataSource()
            updateHeaderSnapshot(value)
        }
        
        // PillAlarmSpecificView, PillAlarmReviseView로부터 전달되어지는 노티 --> 관리화면 reload
        NotificationCenter.default.addObserver(self, selector: #selector(triggerFetchPillAlarmTable), name: Notification.Name("fetchPillAlarmTable"), object: nil)
    }
    
    override func configureNavigation() {
        super.configureNavigation()
        navigationController?.navigationBar.layer.borderWidth = 0
        navigationItem.title = "🤔 나의 복용약"
        
        mainView.customButton.addTarget(self, action: #selector(leftBarButtonClicked), for: .touchUpInside)
        navigationItem.leftBarButtonItem = UIBarButtonItem(customView: mainView.customButton)
        if #available(iOS 16.0, *) {
            navigationItem.leftBarButtonItem?.isHidden = true
        } else {
            // Fallback on earlier versions
            navigationItem.leftBarButtonItem?.customView?.isHidden = true
        }
    }
    
    //MARK: - Header Datasource & SnakeShot
    private func configureHeaderDataSource() {
        
        let headerCellRegistration = mainView.pillManagementHeaderCellRegistration()
        
        headerDataSource = UICollectionViewDiffableDataSource(collectionView: mainView.headerCollecionView, cellProvider: { collectionView, indexPath, itemIdentifier in
            let cell = collectionView.dequeueConfiguredReusableCell(using: headerCellRegistration, for: indexPath, item: itemIdentifier)
            
            return cell
        })
    }
    
    private func updateHeaderSnapshot(_ data : [PillAlarm]) {
        var snapshot = NSDiffableDataSourceSnapshot<PillManagementViewSection, PillAlarm>()
        snapshot.appendSections(PillManagementViewSection.allCases)
        snapshot.appendItems(data, toSection: .main)
        
        headerDataSource.apply(snapshot) // reloadData
        print("PillManageMent UpdateSnapShot - Header ❗️❗️❗️❗️❗️❗️❗️")
    }
    
    //MARK: - Main Datasource & SnapShot
    private func configureMainDataSource() {
        
        let mainCellRegistration = mainView.pillManagementMainCellRegistration()
        
        mainDataSource = UICollectionViewDiffableDataSource(collectionView: mainView.mainCollectionView, cellProvider: { collectionView, indexPath, itemIdentifier in
            let cell = collectionView.dequeueConfiguredReusableCell(using: mainCellRegistration, for: indexPath, item: itemIdentifier)
            cell.delegate = self
            
            return cell
        })
    }
    
    private func updateMainSnapshot(_ data : [Pill]) {
        var snapshot = NSDiffableDataSourceSnapshot<PillManagementViewSection, Pill>()
        snapshot.appendSections(PillManagementViewSection.allCases)
        snapshot.appendItems(data, toSection: .main)
        
        mainDataSource.apply(snapshot) // reloadData
        
        print("PillManageMent UpdateSnapShot - Main ❗️❗️❗️❗️❗️❗️❗️")
    }
    
    //MARK: - 복용약 알림 화면으로 이동하는 부분 ❗️❗️❗️❗️❗️❗️❗️❗️❗️❗️❗️❗️❗️❗️❗️❗️❗️❗️❗️❗️❗️❗️❗️❗️❗️
    @objc private func leftBarButtonClicked(_ sender : UIBarButtonItem){
        let vc =  PillAlarmRegisterViewController()
        vc.setupSheetPresentationLarge()
        
        guard let selectedIndexPaths = mainView.mainCollectionView.indexPathsForSelectedItems else { return }
        let selectedPill = selectedIndexPaths.map{ return mainDataSource.itemIdentifier(for: $0)}
        vc.viewModel.inputSelectedPill.value = selectedPill
        let nav = UINavigationController(rootViewController: vc)
        
        present(nav, animated: true)
    }
    
    //MARK: - 모달 이후에 선택 및 선택 이미지 해제
    private func selectedCellRelease() {
        // 선택된 모든 Cell Image Hidden (데이터상으로는 이미 모두 선택이 해제되어 있음)
        mainView.mainCollectionView.visibleCells.forEach { cell in
            guard let cellCasting = cell as? PillManagementCollectionViewMainCell else { return }
            cellCasting.hiddneSelectedImage()
        }
        mainView.mainCollectionView.deselectAllItems(animated: true)
        hiddenLeftBarButton(mainView.mainCollectionView)
    }
    
    
    // pillAlarm의 조회를 위한 Trigger
    @objc private func triggerFetchPillAlarmTable(_ noti: Notification) {
        print("PillManagementViewController triggerFetchPillAlarmTable ❗️❗️❗️❗️❗️❗️❗️")
        selectedCellRelease()
        viewModel.fetchPillAlarmItemTrigger.value = ()
        
        view.makeToast("복용약 알림이 설정되었습니다 ✅", duration: 2, position: .center)
    }
    
    deinit {
        print(#function, " - ✅ PillManagementViewController")
    }
}

//MARK: - Collection View Delegate
extension PillManagementViewController : UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {

        //MARK: - 복용약 알림 수정으로 넘어가면 화면
        if collectionView.cellForItem(at: indexPath) is PillManagementCollectionViewHeaderCell {
            guard let data = headerDataSource.itemIdentifier(for: indexPath) else { return }

            //MARK: - 그룹에 속한 Pill 목록 띄우는 팝업뷰 나타남
            let vc = PopUpPillAlarmGroupViewController()
            vc.viewModel.reviseAlarmPopUpTrigger.value = data.alarmName // 여기는 model을 사용하여 Pill 목록을 띄우는 것
            
            let alert = UIAlertController(title: "🌟" + data.alarmName, message: nil, preferredStyle: .actionSheet)
            alert.view.tintColor = DesignSystem.colorSet.lightBlack

            let constraintHeight = NSLayoutConstraint(
                item: alert.view!, attribute: NSLayoutConstraint.Attribute.height, relatedBy: NSLayoutConstraint.Relation.equal, toItem: nil, attribute:
                    NSLayoutConstraint.Attribute.notAnAttribute, multiplier: 1, constant: UIScreen.main.bounds.height / 3)
            alert.view.addConstraint(constraintHeight)
            alert.setValue(vc, forKey: "contentViewController")
            
            //MARK: - 복용약 그룹 수정화면으로 넘어감
            let confirmAction = UIAlertAction(title: "⚠️ 수정할래요", style: .cancel) { [weak self] (action) in
                guard let self = self else { return }
                
                let vc =  PillAlarmReviseViewController()
                vc.setupSheetPresentationLarge()
                vc.viewModel.reviseAlarmPopUpTrigger.value = data.alarmName // 여기는 model을 사용하여 정보를 불러와 수정하는 것

                let nav = UINavigationController(rootViewController: vc)
                
                present(nav, animated: true)
                
            }
            alert.addAction(confirmAction)
            
            present(alert, animated: true) { [weak self] in
                guard let self = self else { return }
                let tapGesture = UITapGestureRecognizer(target: self, action: #selector(self.dismissAlertController))
                alert.view.superview?.subviews[0].addGestureRecognizer(tapGesture)
            }
            
        }
        
        if let cell = collectionView.cellForItem(at: indexPath) as? PillManagementCollectionViewMainCell {
            cell.showSelectedImage()
            hiddenLeftBarButton(collectionView)
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didDeselectItemAt indexPath: IndexPath) {
        if let cell = collectionView.cellForItem(at: indexPath) as? PillManagementCollectionViewMainCell {
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
    
    @objc private func dismissAlertController(){
        self.dismiss(animated: true, completion: nil)
    }
}

//MARK: - CollectionView swipe delegate
extension PillManagementViewController : SwipeCollectionViewCellDelegate {
    func collectionView(_ collectionView: UICollectionView, editActionsForItemAt indexPath: IndexPath, for orientation: SwipeCellKit.SwipeActionsOrientation) -> [SwipeCellKit.SwipeAction]? {
        guard orientation == .right else { return nil }
        
        let deleteAction = SwipeAction(style: .destructive, title: "삭제") { [weak self] action, indexPath in
            guard let self = self else { return }
            
            let confirmAction = UIAlertAction(title: "지워주세요", style: .default) { (action) in
                
                self.viewModel.updatePillItemisDeleteTrigger.value = self.mainDataSource.itemIdentifier(for: indexPath)
                self.hiddenLeftBarButton(collectionView)
                
            }
            
            let cancelAction = UIAlertAction(title: "취소할래요", style: .cancel)
            cancelAction.setValue(UIColor.red, forKey: "titleTextColor")
            
            self.showAlert(title: "등록된 복용약 삭제", message: "등록된 복용약 삭제하시겠습니까? 🥲", actions: [confirmAction, cancelAction])
        }
        
        let editImageAction = SwipeAction(style: .default, title: "이미지 수정") { [weak self] action, indexPath in
            guard let self = self else { return }
            let vc = RegisterPillViewController()
            vc.editMode = true
            vc.modifyView(itemSeq: mainDataSource.itemIdentifier(for: indexPath)?.itemSeq.toString)
            vc.pillListDelegate = self
            vc.setupSheetPresentationLarge()
            
            let nav = UINavigationController(rootViewController: vc)
            
            present(nav, animated: true)
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
