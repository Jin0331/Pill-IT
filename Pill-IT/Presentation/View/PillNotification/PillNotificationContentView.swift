//
//  PillNotificationContentView.swift
//  Pill-IT
//
//  Created by JinwooLee on 3/20/24.
//

import UIKit
import SnapKit
import Then

final class PillNotificationContentView : BaseView {
    
    let emptyImage = UIImageView().then {
        $0.image = DesignSystem.imageByGY.empty2
        $0.contentMode = .scaleAspectFit
    }
    
    lazy var mainCollectionView : UICollectionView = {
        let view = UICollectionView(frame: .zero, collectionViewLayout: createLayout())
        view.backgroundColor = DesignSystem.colorSet.white
        view.allowsMultipleSelection = true
        
       return view
    }()
    
    let emptyButton = UIButton().then {
        $0.backgroundColor = .clear
    }
    
    override func configureHierarchy() {
        addSubview(emptyImage)
        addSubview(mainCollectionView)
        addSubview(emptyButton)
    }
    
    override func configureLayout() {
        emptyImage.snp.makeConstraints { make in
            make.center.equalTo(safeAreaLayoutGuide)
        }
        mainCollectionView.snp.makeConstraints { make in
            make.edges.equalTo(safeAreaLayoutGuide)
        }
        emptyButton.snp.makeConstraints { make in
            make.edges.equalTo(emptyImage)
        }
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
        section.interGroupSpacing = 15
        
        let layout = UICollectionViewCompositionalLayout(section: section)
        
        return layout
    }
    
    func pillNotificationContentCellRegistration() -> UICollectionView.CellRegistration<PillNotificationContentViewCollectionViewCell, PillAlarmDate>  {
        
        return UICollectionView.CellRegistration<PillNotificationContentViewCollectionViewCell, PillAlarmDate> { cell, indexPath, itemIdentifier in
            cell.updateUI(itemIdentifier)
        }
    }
    
    func emptyViewisHidden(itemCount : Int) {
        mainCollectionView.isHidden = itemCount < 1 ? true : false
        emptyImage.isHidden = itemCount < 1 ? false : true
        emptyButton.isHidden = itemCount < 1 ? false : true
    }
    
    
    deinit {
        print(#function, " - ✅ PillNotificationContentView")
    }
}
