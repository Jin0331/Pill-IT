//
//  RegisterPill.swift
//  Pill-IT
//
//  Created by JinwooLee on 3/7/24.
//

import UIKit
import Kingfisher

class RegisterPillViewController : BaseViewController {
    
    let mainView = RegisterPillView()
    var viewModel = RegisterPillViewModel()
    
    override func loadView() {
        self.view = mainView
        mainView.actionDelegate = self
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        bindData()
    }
    
    private func bindData() {
        textFieldHandler()
    }
    
    override func configureView() {
        mainView.userInputTextfield.delegate = self
    }
    
    private func textFieldHandler() {
        // 2글자 이상 입력될때 실행되도록
        mainView.userInputTextfield.userStoppedTypingHandler = { [weak self] in
            guard let self = self else { return }
            if let criteria = self.mainView.userInputTextfield.text {
                
                let whipeSpaceRemovedText = criteria.replacingOccurrences(of: " ", with: "")
                
                print(whipeSpaceRemovedText)
                
                if whipeSpaceRemovedText.count >= 2 {
                    
                    // Show the loading indicator
                    self.mainView.userInputTextfield.showLoadingIndicator()
                    
                    self.viewModel.callRequestForItemListTrigger.value = whipeSpaceRemovedText
                    self.viewModel.outputItemNameList.bind { [weak self] value in
                        guard let self = self else { return }
                        self.mainView.userInputTextfield.filterStrings(value)
                        
                        // Hide loading indicator
                        self.mainView.userInputTextfield.stopLoadingIndicator()
                    }
                }
            }
        }
        
        // autocomplete이 선택되었을 때
        mainView.userInputTextfield.itemSelectionHandler = { [weak self] item, itemPosition in
            guard let self = self else { return }
            
            self.mainView.userInputTextfield.text = item[itemPosition].title
            self.viewModel.inputItemSeq.value = self.viewModel.outputItemNameSeqList.value[itemPosition]
            
            // 커서 맨 앞으로 옮기기
            self.mainView.userInputTextfield.selectedTextRange = self.mainView.userInputTextfield.textRange(from: self.mainView.userInputTextfield.beginningOfDocument, to: self.mainView.userInputTextfield.beginningOfDocument)
            
            // 기존 autucomplete 삭제
            self.mainView.userInputTextfield.filterItems([])
            self.mainView.endEditing(true)
            
            // 기본이미지 띄우기
            
            self.viewModel.outputLocalImageURL.bind { [weak self] imageUrl in
                guard let self = self else { return }
                
                // API로부터 기본 식약처 이미지를 받아올 수 있을 때
                if let localImage = self.viewModel.outputLocalImageURL.value {
                    let url = URL(fileURLWithPath: localImage)
                    let provider = LocalFileImageDataProvider(fileURL: url)
                    
                    // 비동기 속 비동기이기때문에, main threads로 보내는 코드 필요함
                    DispatchQueue.main.async {
                        self.mainView.pillImageView.kf.setImage(with: provider, options: [.transition(.fade(1))])
                        self.mainView.pillImageView.isHidden = false
                    }
                    
                } else {
                    DispatchQueue.main.async {
                        // 비동기 속 비동기이기때문에, main threads로 보내는 코드 필요함
                        DispatchQueue.main.async {
                            UIView.transition(with: self.mainView.pillImageView,
                                              duration: 3.0,
                                              options: .transitionCrossDissolve,
                                              animations: {
                                self.mainView.pillImageView.image = UIImage(imageLiteralResourceName: "noImage")
                            }, completion: nil)
                            self.mainView.pillImageView.isHidden = false
                        }
                    }
                }
            }
            
        }
    }
    
    deinit {
        print(#function, " - RegisterPillView")
    }
}


//MARK: - View Action Protocol
extension RegisterPillViewController : RegisterPillAction {
    
    func disMissPresent() {
        dismiss(animated: true)
    }
    
    func completePillRegister() {
        
        //TODO: - Databse에 데이터 넣어야 됨
        
        dismiss(animated: true)
    }
    
}

extension RegisterPillViewController :  UITextFieldDelegate {
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        print(#function)
        textField.text = ""
        mainView.pillImageView.isHidden = true
    }

}
