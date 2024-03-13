//
//  PillListView.swift
//  Pill-IT
//
//  Created by JinwooLee on 3/13/24.
//

import UIKit
import SnapKit

final class PillManagementView : BaseView {

    lazy var mainCollectionView : UICollectionView = {
        let view = UICollectionView(frame: .zero, collectionViewLayout: createLayout())
        
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
        let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .fractionalHeight(1.0))
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        
        // Group
        let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .absolute(100))
        
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitems: [item])

        // Section
        let section = NSCollectionLayoutSection(group: group)
        section.interGroupSpacing = 10
        
        return UICollectionViewCompositionalLayout(section: section)
    }
    
    deinit {
        print(#function, " - ✅ PillManagementView")
    }

    
}

