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
    
    lazy var headerCollecionView  : UICollectionView = {
        let view = UICollectionView(frame: .zero, collectionViewLayout: headerCreateLayout())
        view.backgroundColor = DesignSystem.colorSet.white
        
        return view
    }()
    
    //    let headerCollectionViewtitle = UILabel().then {
    //        $0.text = "복용약 알림 목록"
    //        $0.textColor = DesignSystem.colorSet.gray
    //        $0.font = .systemFont(ofSize: 15, weight: .heavy)
    //    }
    
    let mainCollectionViewtitle = UILabel().then {
        $0.text = "복용약 목록"
        $0.textColor = DesignSystem.colorSet.gray
        $0.font = .systemFont(ofSize: 15, weight: .heavy)
    }
    
    lazy var mainCollectionView : UICollectionView = {
        let view = UICollectionView(frame: .zero, collectionViewLayout: mainCreateLayout())
        view.backgroundColor = DesignSystem.colorSet.white
        view.allowsMultipleSelection = true
        
        return view
    }()
    
    let emptyImage = UIImageView().then {
        $0.image = UIImage(named: "Empty")
        $0.contentMode = .scaleAspectFit
    }
    
    let customButton = UIButton(frame: CGRect(x: 0, y: 0, width: 130, height: 40)).then {
        $0.setTitle(" 알림 등록하기", for: .normal)
        $0.titleLabel?.font = .systemFont(ofSize: 15, weight: .heavy)
        $0.setTitleColor(DesignSystem.colorSet.white, for: .normal)
        $0.tintColor = DesignSystem.colorSet.white
        $0.backgroundColor = DesignSystem.colorSet.lightBlack
        $0.setImage(DesignSystem.sfSymbol.alarm, for: .normal)
        $0.layer.borderColor = DesignSystem.colorSet.lightBlack.cgColor
        $0.layer.cornerRadius = 20
        $0.layer.shadowOffset = CGSize(width: 10, height: 5)
        $0.layer.shadowOpacity = 0.1
        $0.layer.shadowRadius = 10
        $0.layer.masksToBounds = false
    }
    
    override func configureHierarchy() {
        
        [headerCollecionView, mainCollectionViewtitle, mainCollectionView, emptyImage].forEach {
            addSubview($0)
        }
    }
    
    override func configureLayout() {
        
        headerCollecionView.snp.makeConstraints { make in
            make.top.horizontalEdges.equalTo(safeAreaLayoutGuide)
            make.height.equalTo(80)
        }
        
        mainCollectionViewtitle.snp.makeConstraints { make in
            make.top.equalTo(headerCollecionView.snp.bottom).offset(10)
            make.leading.equalTo(safeAreaLayoutGuide).inset(20)
        }
        
        mainCollectionView.snp.makeConstraints { make in
            make.top.equalTo(mainCollectionViewtitle.snp.bottom).offset(5)
            make.bottom.horizontalEdges.equalTo(safeAreaLayoutGuide)
        }
        
        emptyImage.snp.makeConstraints { make in
            make.center.equalTo(safeAreaLayoutGuide)
        }
    }
    
    private func headerCreateLayout() -> UICollectionViewLayout {
        
        // Cell
        let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .fractionalHeight(1))
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        
        // Group
        let groupSize = NSCollectionLayoutSize(widthDimension: .absolute(120), heightDimension: .absolute(70))
        
        let group = NSCollectionLayoutGroup.vertical(layoutSize: groupSize, subitems: [item])
        
        // Section
        let section = NSCollectionLayoutSection(group: group)
        section.interGroupSpacing = 0
        section.orthogonalScrollingBehavior = .groupPaging
        
        let layout = UICollectionViewCompositionalLayout(section: section)
        
        return layout
    }
    
    private func mainCreateLayout() -> UICollectionViewLayout {
        
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
    
    func pillManagementHeaderCellRegistration() -> UICollectionView.CellRegistration<PillManagementCollectionViewHeaderCell, PillAlarm>  {
        
        return UICollectionView.CellRegistration<PillManagementCollectionViewHeaderCell, PillAlarm> { cell, indexPath, itemIdentifier in
            cell.updateUI(itemIdentifier)
        }
    }
    
    func pillManagementMainCellRegistration() -> UICollectionView.CellRegistration<PillManagementCollectionViewMainCell, Pill>  {
        
        return UICollectionView.CellRegistration<PillManagementCollectionViewMainCell, Pill> { cell, indexPath, itemIdentifier in
            cell.updateUI(itemIdentifier)
        }
    }
    
    // emptyImage 관련
    // registedPill Count에 따라 hidden
    // 초기값은 false (count가 nil이니까), 이후 등록되면 count < 1 일때 나타나고, > 1이면 사라짐
    func emptyViewisHidden(itemCount : Int) {
        mainCollectionViewtitle.textColor = itemCount < 1 ? UIColor.clear : DesignSystem.colorSet.gray
        emptyImage.isHidden = itemCount < 1 ? false : true
    }
    
    // header collectionView 관련
    func headercollectionViewChangeLayout(itemCount: Int) {
        
        if itemCount < 1 {
            headerCollecionView.snp.updateConstraints { make in
                make.top.horizontalEdges.equalTo(safeAreaLayoutGuide)
                make.height.equalTo(0)
            }
            
            mainCollectionViewtitle.snp.updateConstraints { make in
                make.top.equalTo(headerCollecionView.snp.bottom).offset(10)
                make.leading.equalTo(safeAreaLayoutGuide).inset(20)
            }
            
            mainCollectionView.snp.updateConstraints { make in
                make.top.equalTo(mainCollectionViewtitle.snp.bottom).offset(5)
                make.bottom.horizontalEdges.equalTo(safeAreaLayoutGuide)
            }
        } else {
            headerCollecionView.snp.updateConstraints { make in
                make.top.horizontalEdges.equalTo(safeAreaLayoutGuide)
                make.height.equalTo(80)
            }
            
            mainCollectionViewtitle.snp.updateConstraints { make in
                make.top.equalTo(headerCollecionView.snp.bottom).offset(10)
                make.leading.equalTo(safeAreaLayoutGuide).inset(20)
            }
            
            mainCollectionView.snp.updateConstraints { make in
                make.top.equalTo(mainCollectionViewtitle.snp.bottom).offset(5)
                make.bottom.horizontalEdges.equalTo(safeAreaLayoutGuide)
            }
        }
        
        print("🥲 CollectionView Resize")
    }
    
    
    deinit {
        print(#function, " - ✅ PillManagementView")
    }
}
