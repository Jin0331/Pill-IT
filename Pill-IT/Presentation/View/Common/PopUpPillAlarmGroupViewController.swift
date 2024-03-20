//
//  PopUpPillAlarmGroupViewController.swift
//  Pill-IT
//
//  Created by JinwooLee on 3/21/24.
//

import UIKit

final class PopUpPillAlarmGroupViewController: BaseViewController {

    let viewModel = PopUpPillAlarmGroupViewModel()
    private var dataSource : UICollectionViewDiffableDataSource<PillAlarmViewSection, Pill>!
    
    lazy var mainollectionView : UICollectionView = {
        let view = UICollectionView(frame: .zero, collectionViewLayout: createLayout())
        view.backgroundColor = DesignSystem.colorSet.white
        view.backgroundColor = .red
        
       return view
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        print(#function, "- ❗️PopUpPillAlarmGroupViewController")
        
        configureDataSource()
        bindData()
    }
    
    private func bindData() {
        viewModel.outputCurrentDateAlarmPill.bind { [weak self] value in
            guard let self = self else { return }
            guard let value = value else { return }
            
            print(value, "❗️PopUpPillAlarmGroupViewController")
            updateSnapshot(value)
        }
    }
    
    override func configureLayout() {
            
        mainollectionView.snp.makeConstraints { make in
            make.edges.equalTo(view.safeAreaLayoutGuide)
        }
    }
    
    deinit {
        print(#function, " - ✅ PopUpPillAlarmGroupViewController")
    }

}


//MARK: - SubCollectionView in Cell
extension PopUpPillAlarmGroupViewController {
    
    private func configureDataSource() {
        
        let cellRegistration = PopUpPillAlarmGroupViewControllerCellRegistration()
        dataSource = UICollectionViewDiffableDataSource(collectionView: mainollectionView, cellProvider: { [weak self] collectionView, indexPath, itemIdentifier in
            
            guard let self = self else { return UICollectionViewCell()}
            
            let cell = collectionView.dequeueConfiguredReusableCell(using: cellRegistration, for: indexPath, item: itemIdentifier)
            
            return cell
        })
    }
    
    private func updateSnapshot(_ data : [Pill]) {
        var snapshot = NSDiffableDataSourceSnapshot<PillAlarmViewSection, Pill>()
        snapshot.appendSections(PillAlarmViewSection.allCases)
        snapshot.appendItems(data, toSection: .main)
        
        dataSource.apply(snapshot) // reloadData
        
        print("PillNotificationContentViewCollectionViewCell UpdateSnapShot ❗️❗️❗️❗️❗️❗️❗️")
    }
    
    private func createLayout() -> UICollectionViewLayout {
        
        // Cell
        let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .estimated(100))
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        
        // Group
        let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .estimated(100))
        
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitems: [item])

        // Section
        let section = NSCollectionLayoutSection(group: group)
        section.interGroupSpacing = 5
        
        let layout = UICollectionViewCompositionalLayout(section: section)
        
        return layout
    }
    
    private func PopUpPillAlarmGroupViewControllerCellRegistration() -> UICollectionView.CellRegistration<PillAlarmCollectionViewCell, Pill>  {
        
        return UICollectionView.CellRegistration<PillAlarmCollectionViewCell, Pill> { cell, indexPath, itemIdentifier in
            cell.updateUI(itemIdentifier)
        }
    }
}