//
//  PillListView.swift
//  Pill-IT
//
//  Created by JinwooLee on 3/13/24.
//

import UIKit
import SnapKit
import Then

final class PillManagementView : BaseView {

    lazy var mainCollectionView : UICollectionView = {
        let view = UICollectionView(frame: .zero, collectionViewLayout: createLayout())
        view.backgroundColor = DesignSystem.colorSet.white
        view.allowsMultipleSelection = true
        
       return view
    }()

    let customButton = UIButton(frame: CGRect(x: 0, y: 0, width: 130, height: 40)).then {
        $0.setTitle(" 알림 등록하기", for: .normal)
        $0.titleLabel?.font = .systemFont(ofSize: 15, weight: .heavy)
        $0.setTitleColor(DesignSystem.colorSet.lightBlack, for: .normal)
        $0.tintColor = DesignSystem.colorSet.lightBlack
        $0.backgroundColor = DesignSystem.colorSet.white
        $0.setImage(UIImage(systemName: "alarm"), for: .normal)
        $0.layer.borderColor = DesignSystem.colorSet.lightBlack.cgColor
        $0.layer.cornerRadius = 20
        $0.layer.shadowOffset = CGSize(width: 10, height: 5)
        $0.layer.shadowOpacity = 0.1
        $0.layer.shadowRadius = 10
        $0.layer.masksToBounds = false
    }
    
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
        let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .estimated(160))
        
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitems: [item])

        // Section
        let section = NSCollectionLayoutSection(group: group)
        section.interGroupSpacing = 15
        
        let layout = UICollectionViewCompositionalLayout(section: section)
        
        return layout
    }
    
    func pillManagementCellRegistration() -> UICollectionView.CellRegistration<PillManagementCollectionViewCell, Pill>  {
        
        return UICollectionView.CellRegistration<PillManagementCollectionViewCell, Pill> { cell, indexPath, itemIdentifier in
            cell.updateUI(itemIdentifier)
        }
    }
    
    
    deinit {
        print(#function, " - ✅ PillManagementView")
    }
}
