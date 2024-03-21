//
//  PillManagementCollectionViewHeaderCell.swift
//  Pill-IT
//
//  Created by JinwooLee on 3/21/24.
//

import UIKit
import SnapKit
import Then

final class PillManagementCollectionViewHeaderCell : UICollectionViewCell {
    
    let bgView = UIView().then {
        $0.layer.cornerRadius = DesignSystem.viewLayout.cornerRadius
        $0.layer.shadowOffset = CGSize(width: 10, height: 5)
        $0.layer.shadowOpacity = 0.2
        $0.layer.shadowRadius = 10
        $0.layer.masksToBounds = false
        $0.backgroundColor = .white
    }
    
    let groupTitleLabel = UILabel().then {
        $0.textColor = DesignSystem.colorSet.lightBlack
        $0.font = .systemFont(ofSize: 17, weight: .heavy)
        $0.numberOfLines = 0
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        configureHierarchy()
        configureLayout()
        configureView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func configureHierarchy() {
        contentView.addSubview(bgView)
        
        bgView.addSubview(groupTitleLabel)
    }
    
    private func configureLayout() {
        bgView.snp.makeConstraints { make in
            make.verticalEdges.equalTo(contentView.safeAreaLayoutGuide)
            make.horizontalEdges.equalTo(contentView.safeAreaLayoutGuide).inset(10)
        }
        
        groupTitleLabel.snp.makeConstraints { make in
            make.edges.equalToSuperview().inset(10)
        }
    }
    
    private func configureView() {
        backgroundColor = DesignSystem.colorSet.white
        
    }
    
    func updateUI(_ itemIdentifier : PillAlarm) {
        
        print("🔆 PillManagementCollectionViewHedaerCell")
        
        groupTitleLabel.text = itemIdentifier.alarmName
    }
}
