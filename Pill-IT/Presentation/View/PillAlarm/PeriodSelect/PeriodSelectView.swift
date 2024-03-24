//
//  PeriodSelectView.swift
//  Pill-IT
//
//  Created by JinwooLee on 3/17/24.
//

import UIKit
import SnapKit
import Then

final class PeriodSelectView: BaseView {

    lazy var mainCollectionView = UICollectionView(frame: .zero, collectionViewLayout: createLayout()).then {
        $0.backgroundColor = DesignSystem.colorSet.white
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
        var configuration = UICollectionLayoutListConfiguration(appearance: .grouped)
        configuration.backgroundColor = DesignSystem.colorSet.white
        configuration.showsSeparators = true
        
        let layout = UICollectionViewCompositionalLayout.list(using: configuration)
        
        return layout
    }
    
    func periodSelectCellRegistration() -> UICollectionView.CellRegistration<UICollectionViewListCell, PeriodCase> {
        
        let cellRegistration = UICollectionView.CellRegistration<UICollectionViewListCell, PeriodCase> { cell, indexPath, itemIdentifier in
            
            var content = UIListContentConfiguration.subtitleCell()
            content.text = itemIdentifier.rawValue
            cell.contentConfiguration = content
            
            var background = UIBackgroundConfiguration.listPlainCell()
            background.backgroundColor = DesignSystem.colorSet.white
            
            cell.backgroundConfiguration = background
        }
        
        return cellRegistration
    }
    
    deinit {
        print(#function, " - ✅ PeriodSelectView")
    }
}
