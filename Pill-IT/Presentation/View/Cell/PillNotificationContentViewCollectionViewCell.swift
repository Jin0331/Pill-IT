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
        
        $0.text = "⏰ 오전 6:00"
        $0.backgroundColor = .green
    }
    
    let alarmTitleLabel = UILabel().then {
        $0.font = .systemFont(ofSize: 22, weight: .bold)
        $0.textColor = DesignSystem.colorSet.lightBlack
        
        $0.text = "같이먹으면죽을지도몰라🥲"
        $0.backgroundColor = .green
    }
    
    override func configureHierarchy() {
        
        contentView.addSubview(bgView)
        
        [alarmTimeLabel, alarmTitleLabel].forEach { bgView.addSubview($0) }
    }
    
    override func configureLayout() {
        
        bgView.snp.makeConstraints { make in
            make.edges.equalTo(contentView.safeAreaLayoutGuide)
        }
        
        alarmTimeLabel.snp.makeConstraints { make in
            make.top.leading.equalToSuperview().inset(15)
            make.height.equalTo(40)
        }
        
        alarmTitleLabel.snp.makeConstraints { make in
            make.top.equalTo(alarmTimeLabel.snp.bottom).offset(10)
            make.leading.equalTo(alarmTimeLabel)
            make.height.equalTo(50)
        }
    }
    
    func updateUI(_ itemIdentifier : PillAlarmDate) {
        print("🔆 PillNotificationContentViewCollectionViewCell updateUI")
        alarmTimeLabel.text = itemIdentifier.alarmDate.toStringTime(dateFormat: "a h:mm")
        alarmTitleLabel.text = itemIdentifier.alarmName
    }
    
}
