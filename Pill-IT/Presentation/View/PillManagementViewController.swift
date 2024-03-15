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
//TODO: - 셀 선택은 알림 등록하기 버튼 활성
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
