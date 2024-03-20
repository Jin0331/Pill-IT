//
//  PillNotificationContentViewCollectionViewCell.swift
//  Pill-IT
//
//  Created by JinwooLee on 3/20/24.
//

import UIKit
import SnapKit
import Then

final class PillNotificationContentViewCollectionViewCell: BaseCollectionViewCell {
    
    let viewModel = PillNotificationSubViewModel()
    private var dataSource : UICollectionViewDiffableDataSource<PillAlarmViewSection, Pill>!
    
    let bgView = UIView().then {
        $0.layer.cornerRadius = DesignSystem.viewLayout.cornerRadius
        $0.layer.shadowOffset = CGSize(width: 1, height: 2)
        $0.layer.shadowOpacity = 0.05
        $0.layer.shadowRadius = 10
        $0.layer.masksToBounds = false
        $0.backgroundColor = .white
    }
    
    let alarmTimeLabel = UILabel().then {
        $0.font = .systemFont(ofSize: 18, weight: .bold)
        $0.textColor = DesignSystem.colorSet.lightBlack
    }
    
    let alarmTitleLabel = UILabel().then {
        $0.font = .systemFont(ofSize: 18, weight: .heavy)
        $0.textColor = DesignSystem.colorSet.lightBlack
    }
    
    lazy var subCollectionView : UICollectionView = {
        let view = UICollectionView(frame: .zero, collectionViewLayout: createLayout())
        view.backgroundColor = DesignSystem.colorSet.white
        view.allowsMultipleSelection = true
        
       return view
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        print(#function, "- ❗️PillNotificationContentViewCollectionViewCell")
        
        configureDataSource()
        bindData()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    private func bindData() {
        viewModel.outputCurrentDateAlarmPill.bind { [weak self] value in
            guard let self = self else { return }
            guard let value = value else { return }
            
            print(value, "❗️PillNotificationContentViewCollectionViewCell")
            updateSnapshot(value)
        }
    }
    
    override func configureHierarchy() {
        
        contentView.addSubview(bgView)
        
        [alarmTimeLabel, alarmTitleLabel, subCollectionView].forEach { bgView.addSubview($0) }
    }
    
    override func configureLayout() {
        
        bgView.snp.makeConstraints { make in
            make.edges.equalTo(contentView.safeAreaLayoutGuide)
        }
        
        alarmTimeLabel.snp.makeConstraints { make in
            make.top.leading.equalToSuperview().inset(10)
            make.height.equalTo(30)
        }
        
        alarmTitleLabel.snp.makeConstraints { make in
            make.top.equalTo(alarmTimeLabel.snp.bottom).offset(3)
            make.leading.equalTo(alarmTimeLabel)
            make.height.equalTo(30)
        }
        
        subCollectionView.snp.makeConstraints { make in
            make.top.equalTo(alarmTitleLabel.snp.bottom).offset(3)
            make.bottom.horizontalEdges.equalTo(contentView.safeAreaLayoutGuide)
        }
    }
    
    func updateUI(_ itemIdentifier : PillAlarmDate) {
        print("🔆 PillNotificationContentViewCollectionViewCell updateUI")
        alarmTimeLabel.text = itemIdentifier.alarmDate.toStringTime(dateFormat: "a h:mm")
        alarmTitleLabel.text = itemIdentifier.alarmName
    }
    
    deinit {
        print(#function, " - ✅ PillNotificationContentViewCollectionViewCell")
    }
    
}

//MARK: - SubCollectionView in Cell
extension PillNotificationContentViewCollectionViewCell {
    
    private func configureDataSource() {
        
        let cellRegistration = pillNotificationContentSubCellRegistration()
        dataSource = UICollectionViewDiffableDataSource(collectionView: subCollectionView, cellProvider: { [weak self] collectionView, indexPath, itemIdentifier in
            
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
        let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .fractionalHeight(1))
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        
        // Group
        let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .estimated(50))
        
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitems: [item])

        // Section
        let section = NSCollectionLayoutSection(group: group)
        section.interGroupSpacing = 5
        
        let layout = UICollectionViewCompositionalLayout(section: section)
        
        return layout
    }
    
    private func pillNotificationContentSubCellRegistration() -> UICollectionView.CellRegistration<PillAlarmCollectionViewCell, Pill>  {
        
        return UICollectionView.CellRegistration<PillAlarmCollectionViewCell, Pill> { cell, indexPath, itemIdentifier in
            cell.updateUI(itemIdentifier)
        }
    }
}
