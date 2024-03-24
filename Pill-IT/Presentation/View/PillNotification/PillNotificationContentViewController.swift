//
//  PillNotificationContentViewController.swift
//  Pill-IT
//
//  Created by JinwooLee on 3/20/24.
//

import UIKit
import SwipeCellKit

final class PillNotificationContentViewController: BaseViewController {
    
    let mainView = PillNotificationContentView()
    var viewModel = PillNotificationViewModel()
    private var dataSource : UICollectionViewDiffableDataSource<PillNotificationContent, PillAlarmDate>!
    
    init(currentDate : Date) {
        super.init(nibName: nil, bundle: nil)
        viewModel.inputCurrentDate.value = currentDate
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func loadView() {
        view = mainView
        mainView.mainCollectionView.delegate = self
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        print(#function, "❗️PillNotificationContentViewController")
        
        configureDataSource()
        bindData()
    }
    
    private func bindData() {
        viewModel.outputCurrentDateAlarm.bind { [weak self] value in
            guard let self = self else { return }
            guard let value = value else { return }
            
            updateSnapshot(value)
        }
    }

    private func configureDataSource() {
        
        let cellRegistration = mainView.pillNotificationContentCellRegistration()
        dataSource = UICollectionViewDiffableDataSource(collectionView: mainView.mainCollectionView, cellProvider: { [weak self] collectionView, indexPath, itemIdentifier in
            guard let self = self else { return UICollectionViewCell()}
            guard let pillList = itemIdentifier.alarmGroup.first?.pillList else { return UICollectionViewCell()}
            
            let cell = collectionView.dequeueConfiguredReusableCell(using: cellRegistration, for: indexPath, item: itemIdentifier)
            
            cell.actionDelegate = self
            cell.delegate = self
            cell.viewModel.inputCurrentDateAlarmPill.value = Array(pillList)
            cell.viewModel.inputCurrentGroupID.value = itemIdentifier.alarmName
            
            return cell
        })
    }
    
    private func updateSnapshot(_ data : [PillAlarmDate]) {
        var snapshot = NSDiffableDataSourceSnapshot<PillNotificationContent, PillAlarmDate>()
        snapshot.appendSections(PillNotificationContent.allCases)
        snapshot.appendItems(data, toSection: .main)
        
        dataSource.apply(snapshot) // reloadData
        print("PillNotificationContentViewController UpdateSnapShot ❗️❗️❗️❗️❗️❗️❗️")
    }

    deinit {
        print(#function, " - PillNotificationContentViewController ✅")
    }
}

//MARK: - CollectionView Deleagte
extension PillNotificationContentViewController : UICollectionViewDelegate {
    
}

//MARK: - swipe
extension PillNotificationContentViewController : SwipeCollectionViewCellDelegate {
    func collectionView(_ collectionView: UICollectionView, editActionsForItemAt indexPath: IndexPath, for orientation: SwipeCellKit.SwipeActionsOrientation) -> [SwipeCellKit.SwipeAction]? {
        guard orientation == .right else { return nil }
        
        let deleteAction = SwipeAction(style: .destructive, title: nil) { [weak self] action, indexPath in
            guard let self = self else { return }
            
            let confirmAction = UIAlertAction(title: "지워주세요", style: .default) { (action) in
                
                self.viewModel.updatePillItemisDeleteTrigger.value = self.dataSource.itemIdentifier(for: indexPath)
                
            }
            
            let cancelAction = UIAlertAction(title: "취소할래요", style: .cancel)
            cancelAction.setValue(UIColor.red, forKey: "titleTextColor")
            
            self.showAlert(title: "등록된 알림 삭제", message: "복용약의 알림을 삭제하시겠습니까? 🥲", actions: [confirmAction, cancelAction])
        }
        
        // customize the action appearance
        deleteAction.image = DesignSystem.pillAlarmSwipeImage.trash
        deleteAction.font = .systemFont(ofSize: 17, weight: .heavy)
        deleteAction.hidesWhenSelected = true
        
        return [deleteAction]
    }
    
    
}

//MARK: - Delegate Action
extension PillNotificationContentViewController : PillNotificationAction {
    func containPillButton(_ groupID : String?, _ data : [Pill]?) {
        
        guard let groupID = groupID else { return }
        
        //MARK: - 그룹에 속한 Pill 목록 띄우는 팝업뷰 나타남
        let vc = PopUpPillAlarmGroupViewController()
        vc.viewModel.reviseAlarmPopUpTrigger.value = groupID // 여기는 model을 사용하여 Pill 목록을 띄우는 것
        
        let alert = UIAlertController(title: "🌟" + groupID, message: nil, preferredStyle: .actionSheet)
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
            vc.viewModel.reviseAlarmPopUpTrigger.value = groupID // 여기는 model을 사용하여 정보를 불러와 수정하는 것

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
    
    @objc private func dismissAlertController(){
        self.dismiss(animated: true, completion: nil)
    }
}
