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

class PillManagementViewController : BaseViewController {
    
    let mainView = PillManagementView()
    let viewModel = PillManagementViewModel()
    private var dataSource : UICollectionViewDiffableDataSource<PillManagementViewSection, Pill>!
    
    override func loadView() {
        view = mainView
        mainView.mainCollectionView.delegate = self
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureDataSource()
        bindData()
    }
    
    private func bindData() {
        viewModel.outputRegisteredPill.bind { [weak self] value in
            guard let self = self else { return }
            
            updateSnapshot()
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
    
    private func updateSnapshot() {
        
        guard let outputRegisteredPill = viewModel.outputRegisteredPill.value else { print("안찍히냐");return }
        var snapshot = NSDiffableDataSourceSnapshot<PillManagementViewSection, Pill>()
        snapshot.appendSections(PillManagementViewSection.allCases)
        snapshot.appendItems(outputRegisteredPill, toSection: .main)
        
        dataSource.apply(snapshot) // reloadData
    }
    
    @objc func leftBarButtonClicked(_ sender : UIBarButtonItem){
        print(#function, mainView.mainCollectionView.indexPathsForSelectedItems)
        
        let vc =  AlarmViewController()
        navigationController?.pushViewController(vc, animated: true)
    }
    
    deinit {
        print(#function, " - ✅ PillManagementViewController")
    }
}

//MARK: - Collection View Delegate
//TODO: - 셀 선택은 알림 등록하기 버튼 활성 - 완료
//TODO: - Cell Swipe에서 자세히, 삭제 추가 해야됨
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

// cell swipe
extension PillManagementViewController : SwipeCollectionViewCellDelegate {
    func collectionView(_ collectionView: UICollectionView, editActionsForItemAt indexPath: IndexPath, for orientation: SwipeCellKit.SwipeActionsOrientation) -> [SwipeCellKit.SwipeAction]? {
        guard orientation == .left else { return nil }

        let deleteAction = SwipeAction(style: .destructive, title: "삭제") { action, indexPath in
            // handle action by updating model with deletion
            print("지워집니당~")
            print(indexPath)
        }
        
        let editImageAction = SwipeAction(style: .default, title: "이미지 수정") { action, indexPath in
            print("수정")
        }
        
        let moreInfoAction = SwipeAction(style: .default, title: "정보") { action, indexPath in
            print("더보기")
        }

        // customize the action appearance
        deleteAction.image = DesignSystem.swipeImage.trash
        editImageAction.image = DesignSystem.swipeImage.edit
        moreInfoAction.image = DesignSystem.swipeImage.more
        
        editImageAction.backgroundColor = DesignSystem.swipeColor.edit
        moreInfoAction.backgroundColor = DesignSystem.swipeColor.more
        
        deleteAction.font = .systemFont(ofSize: 17, weight: .heavy)
        editImageAction.font = .systemFont(ofSize: 17, weight: .heavy)
        moreInfoAction.font = .systemFont(ofSize: 17, weight: .heavy)
        
        
        return [deleteAction, editImageAction, moreInfoAction]
    }
    
    func collectionView(_ collectionView: UICollectionView, editActionsOptionsForItemAt indexPath: IndexPath, for orientation: SwipeActionsOrientation) -> SwipeOptions {
        var options = SwipeOptions()
        options.transitionStyle = .reveal
        
        return options
    }
    
}
