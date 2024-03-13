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
import Kingfisher

class PillManagementViewController : BaseViewController {

    let mainView = PillManagementView()
    private let viewModel = PillManagementViewModel()
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
        navigationItem.title = "나의 복용약 목록"
    }
    
    private func configureDataSource() {
        
        let cellRegistration = UICollectionView.CellRegistration<PillManagermentCollectionViewCell, Pill> { cell, indexPath, itemIdentifier in
            
            let provider = LocalFileImageDataProvider(fileURL: itemIdentifier.urlPathToURL)
            cell.itemImage.kf.setImage(with: provider, options: [.transition(.fade(0.7))])
            cell.itemNameLabel.text = itemIdentifier.itemName
            cell.entpNameLabel.text = itemIdentifier.entpName
            cell.productTypeLabel.text = itemIdentifier.entpName // realm table 수정 필요
        }
        
        dataSource = UICollectionViewDiffableDataSource(collectionView: mainView.mainCollectionView, cellProvider: { collectionView, indexPath, itemIdentifier in
            let cell = collectionView.dequeueConfiguredReusableCell(using: cellRegistration, for: indexPath, item: itemIdentifier)
            
            return cell
        })
    }

    private func updateSnapshot() {

        guard let outputRegisteredPill = viewModel.outputRegisteredPill.value else { print("안찍히냐");return }
        
        print(outputRegisteredPill, "updateSnapshot")
        
        var snapshot = NSDiffableDataSourceSnapshot<PillManagementViewSection, Pill>()
        snapshot.appendSections(PillManagementViewSection.allCases)
        snapshot.appendItems(outputRegisteredPill, toSection: .main)

        dataSource.apply(snapshot) // reloadData
    }
    
    deinit {
        print(#function, " - ✅ PillManagementViewController")
    }
    
}

extension PillManagementViewController : UICollectionViewDelegate {
    
}
