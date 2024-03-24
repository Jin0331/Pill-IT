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
        
    weak var actionDelegate : PillNotificationAction?
    
    var viewModel = PopUpPillAlarmGroupViewModel()
    
    let bgView = UIView().then {
        $0.layer.cornerRadius = DesignSystem.viewLayout.cornerRadius
        $0.layer.shadowOffset = CGSize(width: 1, height: 2)
        $0.layer.shadowOpacity = 0.05
        $0.layer.shadowRadius = 10
        $0.layer.masksToBounds = false
        $0.backgroundColor = .white
    }
    
    let alarmTimeLabel = UILabel().then {
        $0.font = .systemFont(ofSize: 22, weight: .bold)
        $0.textColor = DesignSystem.colorSet.lightBlack
    }
    
    let alarmTitleLabel = UILabel().then {
        $0.font = .systemFont(ofSize: 18, weight: .heavy)
        $0.textColor = DesignSystem.colorSet.lightBlack
    }
    
    let containPillButton = UIButton().then {
        $0.setImage(DesignSystem.sfSymbol.info, for: .normal)
        $0.tintColor = DesignSystem.colorSet.gray
        $0.backgroundColor = .clear
        $0.layer.cornerRadius = DesignSystem.viewLayout.cornerRadius
    }
    
    let notiDoneButton = UIButton().then { _ in
    }

    override func configureHierarchy() {
        
        contentView.addSubview(bgView)
        
        [alarmTimeLabel, alarmTitleLabel,containPillButton, notiDoneButton].forEach { bgView.addSubview($0) }
    }
    
    override func configureLayout() {
        
        bgView.snp.makeConstraints { make in
            make.edges.equalTo(contentView.safeAreaLayoutGuide)
        }
        
        alarmTimeLabel.snp.makeConstraints { make in
            make.top.equalToSuperview().inset(10)
            make.leading.equalToSuperview().inset(20)
            make.height.equalTo(30)
        }
        
        alarmTitleLabel.snp.makeConstraints { make in
            make.top.equalTo(alarmTimeLabel.snp.bottom).offset(3)
            make.leading.equalTo(alarmTimeLabel)
            make.bottom.equalToSuperview().inset(20)
        }
        
        containPillButton.snp.makeConstraints { make in
            make.leading.equalTo(alarmTimeLabel.snp.trailing).offset(5)
            make.centerY.equalTo(alarmTimeLabel)
            make.size.equalTo(alarmTimeLabel.snp.height).multipliedBy(0.8)
        }
        
        notiDoneButton.snp.makeConstraints { make in
            make.trailing.equalToSuperview().inset(25)
            make.centerY.equalToSuperview()
            make.size.equalTo(50)
        }
        
        
    }
    
    override func configureView() {
        containPillButton.addTarget(self, action: #selector(containPillButtonClicked), for: .touchUpInside)
        notiDoneButton.addTarget(self, action: #selector(notiDoneButtonClicked), for: .touchUpInside)
    }
    
    @objc private func containPillButtonClicked() {
        actionDelegate?.containPillButton(viewModel.outputCurrentGroupID.value, viewModel.outputCurrentDateAlarmPill.value)
    }
    
    @objc private func notiDoneButtonClicked() {
        actionDelegate?.notiDoneButton(viewModel.outputCurrentGroupPK.value, viewModel.outputCurrentDate.value)
    }
    
    func updateUI(_ itemIdentifier : PillAlarmDate) {
        alarmTimeLabel.text = "⏰ " + itemIdentifier.alarmDate.toStringTime(dateFormat: "a h:mm")
        alarmTitleLabel.text = itemIdentifier.alarmName
        
        if itemIdentifier.isDone {
            notiDoneButton.setImage(DesignSystem.imageByGY.check, for: .normal)
            notiDoneButton.alpha = 1
        } else {
            notiDoneButton.setImage(DesignSystem.imageByGY.checkFalse, for: .normal)
            notiDoneButton.alpha = 0.2
        }
    }
    
    deinit {
        print(#function, " - ✅ PillNotificationContentViewCollectionViewCell")
    }
    
}
