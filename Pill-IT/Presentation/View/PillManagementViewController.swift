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

        
//        navigationItem.leftBarButtonItem?.
//        navigationItem.leftBarButtonItem?.action = #selector(navigationBarButtonClicked)
        
        navigationItem.rightBarButtonItem?.target = self
        navigationItem.rightBarButtonItem?.action = #selector(navigationBarButtonClicked)
    }
    
    @objc func navigationBarButtonClicked() { print(#function) }

    
    private func configureDataSource() {
        
        let cellRegistration = mainView.pillManagerMentCellRegistration()
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
    
    deinit {
        print(#function, " - ✅ PillManagementViewController")
    }
    
}

//MARK: - Collection View Delegate
extension PillManagementViewController : UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        print(#function)
    }
}
