//
//  PillAlaamSpecificView.swift
//  Pill-IT
//
//  Created by JinwooLee on 3/18/24.
//

import UIKit
import SnapKit
import Then

class PillAlaamSpecificView: BaseView {
    
    let headerLabel = UILabel().then {
        $0.text = "세부 알림 시간을 설정해주세요 🫡"
        $0.textColor = DesignSystem.colorSet.black
        $0.font = .systemFont(ofSize: 22, weight: .heavy)
        $0.textAlignment = .center
    }
    
    let scrollView = UIScrollView().then {
        $0.backgroundColor = DesignSystem.colorSet.white
        $0.isScrollEnabled = true
        $0.showsVerticalScrollIndicator = true
    }
    
    let contentsView = UIView().then {
        $0.backgroundColor = DesignSystem.colorSet.white
    }
    
    lazy var mainCollectionView : UICollectionView = {
        let view = UICollectionView(frame: .zero, collectionViewLayout: createLayout())
        view.backgroundColor = DesignSystem.colorSet.white

        return view
    }()
    
    let addButton = UIButton().then {
        $0.setTitle("알림 추가하기", for: .normal)
        $0.setTitleColor(DesignSystem.colorSet.white, for: .normal)
        $0.titleLabel?.font = .systemFont(ofSize: 17, weight: .heavy)
        $0.backgroundColor = DesignSystem.colorSet.lightBlack
        $0.layer.cornerRadius = DesignSystem.viewLayout.cornerRadius
    }

    let completeButton = UIButton().then {
        $0.setTitle("완료", for: .normal)
        $0.setTitleColor(DesignSystem.colorSet.white, for: .normal)
        $0.titleLabel?.font = .systemFont(ofSize: 20, weight: .heavy)
        $0.backgroundColor = DesignSystem.colorSet.lightBlack
        $0.layer.cornerRadius = DesignSystem.viewLayout.cornerRadius
    }
    
    override func configureHierarchy() {
        
        [headerLabel, scrollView, scrollView, completeButton].forEach {
            addSubview($0)
        }
        
        scrollView.addSubview(contentsView)
        
        [mainCollectionView, addButton].forEach { contentsView.addSubview($0)}
    }
    
    override func configureLayout() {
        super.configureLayout()
        
        headerLabel.snp.makeConstraints { make in
            make.top.horizontalEdges.equalTo(safeAreaLayoutGuide).inset(20)
            make.height.equalTo(50)
        }
        
        scrollView.snp.makeConstraints {
            $0.top.equalTo(headerLabel.snp.bottom).offset(10)
            $0.horizontalEdges.equalToSuperview()
            $0.bottom.equalTo(completeButton.snp.top)
        }
        
        contentsView.snp.makeConstraints {
            $0.width.equalToSuperview()
            $0.top.bottom.equalToSuperview()
        }
        
        mainCollectionView.snp.makeConstraints { make in
            make.top.equalToSuperview()
            make.horizontalEdges.equalToSuperview().inset(20)
            make.height.equalTo(180)
        }
        
        addButton.snp.makeConstraints { make in
            make.top.equalTo(mainCollectionView.snp.bottom).offset(20)
            make.horizontalEdges.equalTo(mainCollectionView).inset(60)
            make.height.equalTo(50)
            make.bottom.equalToSuperview().inset(20)
        }
        
        completeButton.snp.makeConstraints { make in
            make.horizontalEdges.equalToSuperview().inset(20)
            make.height.equalTo(70)
            make.bottom.equalTo(safeAreaLayoutGuide)
        }
        
    }
    
    
    
    
    
    
    
    
    
    func collectionViewchangeLayout(itemCount: Int) {
        
        print("🥲 CollectionView Resize")
        let oneItemSize = 60 * 3
        let size = itemCount < 4 ? oneItemSize * itemCount : oneItemSize * 3
    
        mainCollectionView.snp.updateConstraints { make in
            make.top.equalToSuperview()
            make.horizontalEdges.equalToSuperview().inset(20)
            make.height.equalTo(size)
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

}
