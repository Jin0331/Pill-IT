//
//  PillAlarmView.swift
//  Pill-IT
//
//  Created by JinwooLee on 3/16/24.
//

import UIKit
import SnapKit
import Then

class PillAlarmView : BaseView {
    
    let exitButton = UIButton().then {
        $0.setImage(DesignSystem.iconImage.clear, for: .normal)
        $0.tintColor = DesignSystem.colorSet.black
    }
    
    let titleLabel = UILabel().then {
        $0.text = "🗓️ 복용 알림 등록하기"
        $0.textColor = DesignSystem.colorSet.black
        $0.font = .systemFont(ofSize: 28, weight: .heavy)
        $0.layer.shadowOffset = CGSize(width: 10, height: 5)
        $0.layer.shadowOpacity = 0.4
        $0.layer.shadowRadius = 10
        $0.layer.masksToBounds = false
    }
    
    let collectionViewtitle = UILabel().then {
        $0.text = "선택한 복용약 목록"
        $0.textColor = DesignSystem.colorSet.gray
        $0.font = .systemFont(ofSize: 15, weight: .heavy)
    }
    
    lazy var mainCollectionView : UICollectionView = {
        let view = UICollectionView(frame: .zero, collectionViewLayout: createLayout())
        view.backgroundColor = DesignSystem.colorSet.white

        return view
    }()
    
    override func configureHierarchy() {
        [exitButton, titleLabel, collectionViewtitle, mainCollectionView].forEach { addSubview($0)}
    }
    
    override func configureLayout() {
        exitButton.snp.makeConstraints { make in
            make.top.trailing.equalToSuperview().inset(20)
            make.size.equalTo(30)
        }
        
        titleLabel.snp.makeConstraints { make in
            make.top.equalTo(exitButton.snp.bottom).offset(10)
            make.horizontalEdges.equalToSuperview().inset(20)
            make.height.equalTo(50)
        }
        
        collectionViewtitle.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom).offset(20)
            make.width.equalTo(120)
            make.leading.equalTo(titleLabel)
        }
        
        mainCollectionView.snp.makeConstraints { make in
            make.top.equalTo(collectionViewtitle.snp.bottom).offset(10)
            make.horizontalEdges.equalTo(titleLabel)
            make.height.equalTo(180)
            
        }
    }
    
    private func createLayout() -> UICollectionViewLayout {
        
        // Cell
        let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .fractionalHeight(1.0))
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        
        // Group
        let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .absolute(50))
        
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitems: [item])

        // Section
        let section = NSCollectionLayoutSection(group: group)
        section.interGroupSpacing = 3
        
        let layout = UICollectionViewCompositionalLayout(section: section)
        
        return layout
    }
    
    func pillAlarmCellRegistration() -> UICollectionView.CellRegistration<PillAlarmCollectionViewCell, Pill>  {
        
        return UICollectionView.CellRegistration<PillAlarmCollectionViewCell, Pill> { cell, indexPath, itemIdentifier in
            cell.updateUI(itemIdentifier)
        }
    }
    
    deinit {
        print(#function, " - ✅ PillAlaramView in-Side")
    }
}
