//
//  PillAlarmSpecificCollectionViewCell.swift
//  Pill-IT
//
//  Created by JinwooLee on 3/18/24.
//

import UIKit
import SnapKit
import Then

final class PillAlarmSpecificCollectionViewCell : BaseCollectionViewCell {
    
    let bgView = UIView().then {
        $0.layer.cornerRadius = DesignSystem.viewLayout.cornerRadius
        $0.layer.shadowOffset = CGSize(width: 1, height: 2)
        $0.layer.shadowOpacity = 0.05
        $0.layer.shadowRadius = 10
        $0.layer.masksToBounds = false
        $0.backgroundColor = .white
    }
    
    let timeLabel = UILabel().then {
        $0.textColor = DesignSystem.colorSet.lightBlack
        $0.textAlignment = .center
        $0.font = .systemFont(ofSize: 22, weight: .heavy)
    }
    
    override func configureHierarchy() {
        contentView.addSubview(bgView)
        [timeLabel].forEach {
            bgView.addSubview($0)
        }
    }
    
    override func configureLayout() {
        bgView.snp.makeConstraints { make in
            make.verticalEdges.equalTo(contentView.safeAreaLayoutGuide)
            make.horizontalEdges.equalTo(contentView.safeAreaLayoutGuide)
        }
        
        timeLabel.snp.makeConstraints { make in
            make.center.equalTo(bgView)
            make.horizontalEdges.equalToSuperview()
            make.height.equalTo(50)
        }
    }
    
    func updateUI(_ itemIdentifier : Date) {
        print("🔆 PillAlarmSpecificCollectionViewCell updateUI")
        timeLabel.text = itemIdentifier.toStringTime(dateFormat: "a hh:mm")
    }
    
}
