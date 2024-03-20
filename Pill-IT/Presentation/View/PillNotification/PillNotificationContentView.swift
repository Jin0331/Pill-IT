//
//  PillNotificationContentView.swift
//  Pill-IT
//
//  Created by JinwooLee on 3/20/24.
//

import UIKit

final class PillNotificationContentView : BaseView {
    
    lazy var mainCollectionView : UICollectionView = {
        let view = UICollectionView(frame: .zero, collectionViewLayout: createLayout())
        view.backgroundColor = DesignSystem.colorSet.white
        view.allowsMultipleSelection = true
        
       return view
    }()
    
    override func configureHierarchy() {
        addSubview(mainCollectionView)
    }
    
    override func configureLayout() {
        mainCollectionView.snp.makeConstraints { make in
            make.edges.equalTo(safeAreaLayoutGuide)
        }
    }
    
    private func createLayout() -> UICollectionViewLayout {
        
        // Cell
        let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .fractionalHeight(1))
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        
        // Group
        let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .estimated(250))
        
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitems: [item])

        // Section
        let section = NSCollectionLayoutSection(group: group)
        section.interGroupSpacing = 15
        
        let layout = UICollectionViewCompositionalLayout(section: section)
        
        return layout
    }
    
    func pillNotificationContentCellRegistration() -> UICollectionView.CellRegistration<PillNotificationContentViewCollectionViewCell, PillAlarmDate>  {
        
        return UICollectionView.CellRegistration<PillNotificationContentViewCollectionViewCell, PillAlarmDate> { cell, indexPath, itemIdentifier in
            cell.updateUI(itemIdentifier)
        }
    }
    
    
    deinit {
        print(#function, " - ✅ PillNotificationContentView")
    }
}
