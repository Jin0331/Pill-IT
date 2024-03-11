//
//  RegisterPillView.swift
//  Pill-IT
//
//  Created by JinwooLee on 3/10/24.
//

import UIKit
import SnapKit
import Then
import SearchTextField
import Kingfisher

class RegisterPillView: BaseView {
    
    weak var actionDelegate : RegisterPillAction?
    
    let exitButton = UIButton().then {
        $0.setImage(DesignSystem.iconImage.clear, for: .normal)
        $0.tintColor = .black
    }
    
    let titleLabel = UILabel().then {
        $0.text = "복용약 등록"
        $0.textColor = .black
        $0.font = .systemFont(ofSize: 40, weight: .heavy)
    }
    
    let userInputTextfield = SearchTextField().then {
        
        $0.attributedPlaceholder = NSAttributedString(string: "복용중인 약을 입력해주세요", attributes: [NSAttributedString.Key.foregroundColor : DesignSystem.colorSet.lightBlack])
        $0.addLeftPadding()
        $0.clearButtonMode = .always
        $0.font = .systemFont(ofSize: 23, weight: .heavy)
        $0.textColor = .black
        $0.layer.borderWidth = 1.0
        $0.layer.borderColor = DesignSystem.colorSet.lightBlack.cgColor
        $0.layer.cornerRadius = 4.0
        $0.layer.borderWidth = 3
        
        $0.theme.font = UIFont.systemFont(ofSize: 15)
        $0.theme.bgColor = UIColor (red: 0.9, green: 0.9, blue: 0.9, alpha: 0.7)
        $0.theme.borderColor = DesignSystem.colorSet.lightBlack
        $0.theme.borderWidth = 3
        $0.theme.separatorColor = UIColor (red: 0.9, green: 0.9, blue: 0.9, alpha: 0.5)
        $0.theme.cellHeight = 50
        $0.forceNoFiltering = false
        $0.hideResultsList()
    }
    
    let pillImageView = UIImageView().then {
        $0.backgroundColor = .darkGray
        $0.layer.borderWidth = 1.0
        $0.layer.borderColor = DesignSystem.colorSet.lightBlack.cgColor
        $0.layer.cornerRadius = 4.0
        $0.layer.borderWidth = 3
        $0.isHidden = true
    }
    
    let completeButton = UIButton().then {
        $0.setTitle("복용약 등록 🥰", for: .normal)
        $0.setTitleColor(DesignSystem.colorSet.white, for: .normal)
        $0.titleLabel?.font = .systemFont(ofSize: 23, weight: .heavy)
        $0.backgroundColor = DesignSystem.colorSet.lightBlack
        $0.layer.cornerRadius = 4.0
    }
    
    
    override func configureHierarchy() {
        [exitButton,titleLabel,userInputTextfield,pillImageView,completeButton].forEach { addSubview($0)}
    }
    
    override func configureLayout() {
        
        exitButton.snp.makeConstraints { make in
            make.top.leading.equalToSuperview().inset(20)
            make.size.equalTo(40)
        }
        
        titleLabel.snp.makeConstraints { make in
            make.top.equalTo(exitButton.snp.bottom).offset(10)
            make.horizontalEdges.equalToSuperview().inset(20)
            make.height.equalTo(50)
        }
        
        userInputTextfield.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom).offset(20)
            make.horizontalEdges.equalTo(titleLabel)
            
            make.height.equalTo(70)
        }
        
        pillImageView.snp.makeConstraints { make in
            make.top.equalTo(userInputTextfield.snp.bottom).offset(40)
            make.centerX.equalTo(userInputTextfield)
            make.width.equalTo(userInputTextfield)
            make.height.equalTo(userInputTextfield.snp.width)
        }
        
        completeButton.snp.makeConstraints { make in
            make.top.equalTo(pillImageView.snp.bottom).offset(40)
            make.horizontalEdges.equalTo(pillImageView)
            make.height.equalTo(userInputTextfield)
        }
    }
    
    override func configureView() {
        super.configureView()
        
        exitButton.addTarget(self, action: #selector(exitButtonClicked), for: .touchUpInside)
        completeButton.addTarget(self, action: #selector(completeButtonClicked), for: .touchUpInside)
    }
    
    @objc func exitButtonClicked(_ sender : UIButton) {
        print(#function)
        actionDelegate?.disMissPresent()
    }
    
    @objc func completeButtonClicked() {
        print(#function)
        actionDelegate?.completePillRegister()
    }
    
    deinit {
        print(#function, " - RegisterPillView in-Side")
    }
    
}
