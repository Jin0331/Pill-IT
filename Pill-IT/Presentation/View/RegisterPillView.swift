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

class RegisterPillView: BaseView {
    
    var actionDelegate : RegisterPillAction?
    var viewModel = RegisterPillViewModel()
    
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
        $0.attributedPlaceholder = NSAttributedString(string: "복용중인 약을 입력해주세요", attributes: [NSAttributedString.Key.foregroundColor : UIColor.darkGray])
        $0.addLeftPadding()
        $0.font = .systemFont(ofSize: 23, weight: .heavy)
        $0.textColor = .black
        $0.layer.borderWidth = 1.0
        $0.layer.borderColor = UIColor.darkGray.cgColor
        $0.layer.cornerRadius = 4.0
        $0.layer.borderWidth = 3
        
        $0.theme.font = UIFont.systemFont(ofSize: 15)
        $0.theme.bgColor = UIColor (red: 0.9, green: 0.9, blue: 0.9, alpha: 0.3)
        $0.theme.borderColor = .darkGray
        $0.theme.borderWidth = 3
        $0.theme.separatorColor = UIColor (red: 0.9, green: 0.9, blue: 0.9, alpha: 0.5)
        $0.theme.cellHeight = 50
        $0.forceNoFiltering = false
        $0.hideResultsList()
    }
    
    override func configureHierarchy() {
        [exitButton,titleLabel,userInputTextfield].forEach { addSubview($0)}
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
    }
    
    override func configureView() {
        super.configureView()
        
        exitButton.addTarget(self, action: #selector(exitButtonClickedd), for: .touchUpInside)
        
        // 2글자 이상 입력될때 실행되도록
        userInputTextfield.userStoppedTypingHandler = {
            if let criteria = self.userInputTextfield.text {
                if criteria.count >= 2 {

                    // Show the loading indicator
                    self.userInputTextfield.showLoadingIndicator()

                    self.viewModel.callRequestTrigger.value = criteria
                    self.viewModel.outputItemName.bind { value in
                        self.userInputTextfield.filterStrings(value)

                        // Hide loading indicator
                        self.userInputTextfield.stopLoadingIndicator()
                    }
                }
            }
        }
        
        // autocomplete이 선택되었을 때
        userInputTextfield.itemSelectionHandler = {item, itemPosition in
            self.userInputTextfield.text = item[itemPosition].title
            
            // 커서 맨 앞으로 옮기기
            self.userInputTextfield.selectedTextRange = self.userInputTextfield.textRange(from: self.userInputTextfield.beginningOfDocument, to: self.userInputTextfield.beginningOfDocument)
        }
    }
    
    @objc func exitButtonClickedd(_ sender : UIButton) {
        
        print(#function)
        actionDelegate?.disMissPresent()
    }

}
