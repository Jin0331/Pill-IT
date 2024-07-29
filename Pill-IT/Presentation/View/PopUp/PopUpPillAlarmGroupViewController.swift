//
//  PopUpPillAlarmGroupViewController.swift
//  Pill-IT
//
//  Created by JinwooLee on 3/21/24.
//

import UIKit
import SnapKit
import Then

final class PopUpPillAlarmGroupViewController: BaseViewController {
    
    let viewModel = PillAlaramRegisterViewModel()
    private var dataSource : UICollectionViewDiffableDataSource<PillAlarmViewSection, Pill>!
    
    lazy var mainCollectionView : UICollectionView = {
        let view = UICollectionView(frame: .zero, collectionViewLayout: createLayout())
        view.backgroundColor = DesignSystem.colorSet.white
        
        return view
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        print(#function, "- ❗️PopUpPillAlarmGroupViewController")
        
        configureDataSource()
        bindData()
    }
    
    private func bindData() {
        viewModel.outputSelectedPill.bind { [weak self] value in
            guard let self = self else { return }
            
            updateSnapshot(value)
        }
    }
    
    override func configureHierarchy() {
        view.addSubview(mainCollectionView)
    }
    
    override func configureLayout() {

        mainCollectionView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
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
        dataSource = UICollectionViewDiffableDataSource(collectionView: mainCollectionView, cellProvider: { [weak self] collectionView, indexPath, itemIdentifier in
            
            guard let _ = self else { return UICollectionViewCell()}
            
            let cell = collectionView.dequeueConfiguredReusableCell(using: cellRegistration, for: indexPath, item: itemIdentifier)
            
            return cell
        })
    }
    
    private func updateSnapshot(_ data : [Pill]) {
        var snapshot = NSDiffableDataSourceSnapshot<PillAlarmViewSection, Pill>()
        snapshot.appendSections(PillAlarmViewSection.allCases)
        snapshot.appendItems(data, toSection: .main)
        
        dataSource.apply(snapshot) // reloadData
    }
    
    private func createLayout() -> UICollectionViewLayout {
        
        // Cell
        let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1), heightDimension: .fractionalHeight(1))
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        
        // Group
        let groupSize = NSCollectionLayoutSize(widthDimension: .absolute(UIScreen.main.bounds.width), heightDimension: .absolute(50))
        
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
